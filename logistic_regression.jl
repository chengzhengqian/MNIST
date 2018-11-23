using MLDatasets
using Flux.Tracker
using Flux.Tracker: forward, update!


function make_onehot(train_y_i,N_class)
    n_shape,=size(train_y_i)
    result=zeros(N_class,n_shape)
    for i =1:n_shape
        result[train_y_i[i]+1,i]=1
    end
    return result
end

train_x, train_y=MNIST.traindata()
test_x, test_y=MNIST.testdata()
w,h,N=size(train_x)
w,h,N_test=size(test_x)
batch_size=100
batch_num=N÷batch_size
lr=1E-5
W1=param(rand(10,w*h)*0.01)
b1=param(rand(10)*0.01)


function epoch()
    for index in randperm(batch_num)
        i=index-1
        train_x_i=train_x[:,:,(1+i*batch_size):((1+i)*batch_size)]
        train_y_i=train_y[(1+i*batch_size):((1+i)*batch_size)]
        train_y_i=make_onehot(train_y_i,10)
        train_x_i_l=reshape(train_x_i,w*h,batch_size)
        y1=W1*train_x_i_l .+ b1
        y2=exp.(y1)
        y2_s=sum(y2,dims=1)
        y2_n=y2./y2_s
        loss=sum(-train_y_i.*log.(y2_n))
        Tracker.back!(loss)
        update!(W1,-W1.grad.*lr)
        update!(b1,-b1.grad.*lr)
        print(loss.data)
        print("\n")
    end
end


function train(n)
    for i in 1:n
        epoch()
    end
end

train(100)

   
