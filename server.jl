using Sockets
using Printf
port=10116

data_points=[]

function toFloat(s)
    return parse(Float32,s)
end
task=@async begin
    server=listen(port)
    while true
        sock=accept(server)
        @async while isopen(sock)
            global data_points,command
            s=readline(sock)
            cs=split(s,',')            
            if(cs[1]=="ADD"&&length(cs)==3)
                data=[toFloat(cs[2]),toFloat(cs[3])]
                data_points=vcat(data_points,[data])
                print("ADD:",data,"\n")
                write(sock,"ADD\n")
            elseif(cs[1]=="CLEAN")
                data_points=[]
                print("CLEAN\n")
                write(sock,"CLEAN\n")
            elseif(cs[1]=="PREDICT")
                r=make_input()
                print_img(r)
                pred=argmax(predict(r))-1
                print("PREDICT:",pred,"\n")
                write(sock,@sprintf("%s\n",pred))
            else
                print("UNKNOWN\n")
                write(sock,"UNKNOWN\n")
            end
        end        
    end
end


# client=connect(10104)
# @async while isopen(client)
#     write(stdout,readline(client,keep=true))
# end


# println(client,"good")

include("naive_Bayes.jl")

function add_point(x,y,img,w)
    for i=-w:w
        for j=-w:w
            if((x+i)>=1 &&(x+i)<=28&&(y+i)>=1 &&(y+i)<=28)
                img[x+i,y+i]=1.0
            end
        end
    end
end

function print_img(img)
    for i=1:14
        for j=1:28
            if(img[2*i,j]>0.3)
                print("*")
            else
                print("..")
            end
        end
        print("\n")
    end    
end
function make_input()
    result=zeros(28,28)
    for i =data_points
        s=map((x)->max(min(trunc(Int,x*28+1),28),1), i)
        add_point(s[1],s[2],result,1)
    end
    return result
end

# i=40;print_img(train_x[:,:,i]);train_y[i]
