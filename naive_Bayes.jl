using MLDatasets

train_x, train_y=MNIST.traindata()
test_x, test_y=MNIST.testdata()


w,h,N=size(train_x)
w,h,N_test=size(test_x)



N_depth=2
N_class=10
count_matrix=zeros(Int32,w,h,N_depth,N_class)
count_class=zeros(Int32,N_class)
count_total=N

function map_to_depth(gray)
    if gray<0.4
        return 1
    # elseif gray<0.6
    #     return 2
    else
        return 2
    end
end

function count_train()
    for i=1:N
        label=train_y[i]+1
        if (i%1000==0)
            print(i)
        end
        count_class[label]+=1
        for x in 1:w
            for y in 1:h
                gray=train_x[x,y,i]
                count_matrix[x,y,map_to_depth(gray),label]+=1
            end
        end
    end
end

function check_cm(x,y)
    for c in 1:N_class
        s=0
        for d in 1:N_depth
            s+=count_matrix[x,y,d,c]
        end
        print(s-count_class[c])
    end
end

function pdc(x,y,d,c)
    return count_matrix[x,y,d,c]/count_class[c]
end

function predict(data)
    results=zeros(N_class)
    for c in 1:N_class
        s=0
        s+=log(count_class[c])
        for x in 1:w
            for y in 1:h
                depth=map_to_depth(data[x,y])
                s+=log(pdc(x,y,depth,c)+1E-3)
            end
        end
        results[c]=s
    end
    return results
end


function result(i)
    r1=predict(test_x[:,:,i])
    r_cal=argmax(r1)-1
    r_exact=test_y[i]
    return r_cal,r_exact
end

function errorRate()
    errorMatrix=zeros(N_class,N_class)
    s=0
    for i in 1:N_test
        r1,r2=result(i)
        if(r1!=r2)
            s+=1
            errorMatrix[r1+1,r2+1]+=1
            # print(r1,",",r2,",",i)
            # print("\n")
        end
    end
    return s/N_test,errorMatrix
end

# count_train()
# e,m=errorRate()
