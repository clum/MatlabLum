classdef test_interp1HoldEndPoints < matlab.unittest.TestCase
    %Test the interp1HoldEndPoints function
    %
    %Christopher Lum
    %lum@uw.edu

    %Version History
    %08/03/24: Created

    methods(Test)
        %Interpolate a single and multiple points all within the range
        %(should function identically to interp1).
        function example01(tc)
            debug = false;

            %Run single interpolation point
            X       = linspace(0,2*pi-deg2rad(30),5);
            V       = 3*sin(X)+2.3;
            Xq      = [1];
            METHOD  = 'linear';

            [Vq] = interp1HoldEndPoints(X,V,Xq,METHOD);
            [Vq_expected] = interp1(X,V,Xq,METHOD);
            tc.verifyTrue(AreMatricesSame(Vq,Vq_expected));

            if(debug)
                figure
                plot(X,V,'rx')
                hold on
                plot(X,V,'r-')
                plot(Xq,Vq,'bo')
            end

            %Run multiple interpolation points
            Xq = [1 0.5 1.5 5.2 4.1];

            [Vq] = interp1HoldEndPoints(X,V,Xq,METHOD);
            [Vq_expected] = interp1(X,V,Xq,METHOD);
            tc.verifyTrue(AreMatricesSame(Vq,Vq_expected));

            if(debug)
                figure
                plot(X,V,'rx')
                hold on
                plot(X,V,'r-')
                plot(Xq,Vq,'bo')
            end

            %Clean up
            close all
        end

        %Outside the end points
        function example02(tc)
            debug = false;

            %Run single interpolation point
            X       = linspace(0,2*pi-deg2rad(30),5);
            V       = 3*sin(X)+2.3;
            Xq      = [-1];
            METHOD  = 'linear';

            [Vq] = interp1HoldEndPoints(X,V,Xq,METHOD);
            Vq_expected = V(1);
            tc.verifyTrue(AreMatricesSame(Vq,Vq_expected));

            if(debug)
                figure
                plot(X,V,'rx')
                hold on
                plot(X,V,'r-')
                plot(Xq,Vq,'bo')
            end

            %Run multiple interpolation points
            Xq = [1 0.5 1.5 5.2 6.8 4.1 -1];

            [Vq] = interp1HoldEndPoints(X,V,Xq,METHOD);
            Vq_expected = [4.36565840642372	3.33282920321186	5.18259200195320	0.305803530640941	0.799999999999999	0.0697063672839765	2.30000000000000];
            tol = 1e-8;
            tc.verifyTrue(AreMatricesSame(Vq,Vq_expected,tol));

            if(debug)
                figure
                plot(X,V,'rx')
                hold on
                plot(X,V,'r-')
                plot(Xq,Vq,'bo')
            end

            %Clean up
            close all
        end

    end
end