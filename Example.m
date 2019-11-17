
%This code was written by James Martini, October 2019 for
%an ANU honours thesis in Fourier Phase Retrieval.

%This package implements the alternating minimisation algorithm using
%convex prior knowledge from the 2018 paper 
%"On Fienup Methods for Sparse Phase Retrieval" written by
%Edouard Jean Robert Pauwels , Amir Beck, Yonina C. Eldar,
%and Shoham Sabach.

%The prior knowledge function g(x) = lambda * norm(x)_1 has been used.
%This prior favours sparse solutions.
%k=sparsity of signal.
%n=length of signal.
%m=number of measurements.
%lambda=soft thresholding parameter, real > 0.
%measType = Linear or quadratic measurements
%trials = number of reconstructions to run for a given x*
%SNR = signal noise (>10000 = noiseless)
%maxIter = number of iterations to apply the AML1 method

clear all
close all
clc

n = 128;
m=3*n;
k = 4;
lambda = 0.2;
SNR=10000; 
maxIter = 150;%Max iterations of AM algorithm
trials = 50; %Number of retrieval experiments for xt
tol = 10^(-8);
previousError = ones(maxIter,1);
bestError = ones(maxIter,1);
rng(555)
measType = "linear";
j=0;
[A,At,xt,c]=buildSparsePhaseProblem(m,n,k,SNR, false,measType);
disp('Running Sparse Phase Retrieval using AML1...')
while ((j < trials) && (bestError(maxIter) > tol))
[xk,reconError] = AML1(n,m,k,maxIter,A,At,xt,c,lambda,isComplex);
if reconError < previousError
    xbest = xk; 
    bestError = reconError;
end
previousError = reconError;
j=j+1;
end
figure(2);subplot(3,1,1)
plot(linspace(-10,10),linspace(-10,10), 'r-')
hold on
plot(xbest,xt, 'bo');
ylabel('xt (True signal)')
xlabel('xk (Reconstructed signal)')
subplot(3,1,2)
Residual = bestError(maxIter)

 ls = 1:1:length(bestError);
 plot(ls,bestError,'.')
 xlabel('Iteration number')
 ylabel('Reconstruction Error')
subplot(3,1,3)
plot(1:length(xt),xt,1:length(xbest),xbest);
legend('True signal','Reconstruction','Location','SouthWest')
ylabel('xt,xk')
xlabel('x(loc)')