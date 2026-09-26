%[text] # Workspace & File Management
%[text] Paths, directories, saving and reloading the workspace
%[text] ## Recommended Folder Structure
%[text] Keep **one folder per week**. MATLAB always looks in the *Current Folder* first, so staying organised means you rarely need to touch the path manually.
%[text] ```
%[text] Documents/
%[text] └── AE2440/
%[text]     ├── week01/     ← put this file here
%[text]     ├── week02/
%[text]     ├── week03/
%[text]     └── data/       ← shared datasets (optional)
%[text] ```
%[text] ### Setting the Current Folder — three ways
%[text] 1. GUI — browser: Navigate in the **Current Folder** panel
%[text] 2. GUI — address bar: Type the path directly above the Current Folder panel
%[text] 3. Code: `cd('path/to/your/folder')` 
%[text] 4.  \
%[text] $x=x+\\epsilon${"editStyle":"visual"}
%[text] ![](text:image:9cda)
%%
%[text] ### Where Are We Right Now?
%[text] Run this section with Ctrl+Enter (Win) or Cmd+Enter (Mac)
pwd %[output:14e2a370]
current_folder = pwd     %[output:038f336b]
dir %[output:5c3e191f]
ls -lhrt %[output:7aa162e7]
%[text] To change folder from code, uncomment the line that matches your OS:
% cd('~/Documents/MATLAB_Course/week01')                        % macOS / Linux
% cd('C:\Users\YourName\Documents\MATLAB_Course\week01')        % Windows
%%
%[text] ### The MATLAB Path
%[text] MATLAB searches a list of folders (the *path*) to find functions and scripts. For this course you **do not** need to manage the path — just keep the Current Folder set to the week you are working on.
%[text] **MATLAB says "... not found,** you are almost certainly in the wrong folder.
%[text] 
which sqrt          
which lesson_intro_workspace_path 
%%
%[text] ### Creating Variables to Save
%[text] Let's build a small workspace representing a simple material measurement. Watch the **Workspace** panel fill up as you run this section.
x = 15 + 5 %[output:5354299e]

%[text] This is human text
%[text] 
code = 1
%[text] This text
%[text] 
%[text] 
%[text] 
% Let's build a small workspace representing a simple material measurement. Watch the Workspace panel fill up as you run this section.
sample_name = 'Steel_Rod_A';
length_m    = 0.500;          % metres
diameter_m  = 0.012;          % metres
mass_kg     = 0.444;          % kilograms

cross_area = pi/4 * diameter_m^2     % m^2 %[output:672d9c9b]
volume_m3  = cross_area * length_m    % m^3 %[output:267e389b]
density    = mass_kg / volume_m3      % kg/m^3 %[output:07c96a47]

%%
%[text] ### **Saving the Workspace**
%[text] **Why?** Long simulations, measured data, results you want to hand off to a colleague, or work you want to resume tomorrow.
%[text] `.mat` files are MATLAB's native binary format. 

% Save the entire workspace:
save('week01_results.mat')

% Save only specific variables:
save('sample_data.mat', 'sample_name', 'mass_kg', 'density')
%%
%[text] **Clear** the workspace 
%[text] Check with `whos` or "Workspace" panel.

clear
disp('Workspace cleared — check the Workspace panel, it is empty.') %[output:093c0a92]
whos            % whos lists variables with size & type — should be empty now

%%
%[text] **Reload** from the `.mat` file:
load('week01_results.mat')
whos             %[output:188d028d]
%[text] Often these three lines at the top a script to guarantee a predictable starting state.
%[text] ```
%[text] clear       % remove all workspace variables
%[text] clc         % clear the Command Window
%[text] close all   % close all figure windows
%[text] ```
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
%[text:image:9cda]
%   data: {"align":"baseline","height":80,"src":"data:image\/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHEAAABQCAYAAAAujppDAAAACXBIWXMAAAsTAAALEwEAmpwYAAAgAElEQVR4nO2debAl11nYf+d0971vn00ja6QZjeVFtmUsW4sXCMgG4kDKmIKKHRKKCgYSkj8ioJIKaxWuVHCAIiHGzsJWpICqAGWDvGAIxmBj2VqsdWYkWaMZWaPZNTOa5a3z7rt9vvxxtu903yeN7CxFyj315vbtPsu3b+d0X3Ps2DHh68ff6sP+vwbg68fXftQiX1fEv+3H1zXx\/4Oj\/sjHPwaAATAGgwEDxl\/AGP\/FmM00VhAxCAICiPiPeFcEI\/5TjG+LCNECpLbi+0uAxWAQA8aYBJs1BoMNsBjf34CRMG4cL40V5tEwiRCNj8cxjB3xDzQwRpCIf4GuBBgV3jgEE3AVMnQTjkBXT2sJeBqMIdNejB\/TmERIwdPR4fGJhxOhvvfeLwbg4yATACcTmEAYEcGJIC5814xQBJQ0Zyaebi+R8uVUGd8eATrtiz75hijkEyGkaNzpYyYQvsttBbMGyUz6btKFYtwoKFEok5KAMVYJLSUfpItL4gZ109SIlHD2Dw+JdBCwGMSSmBXRFgRc5Kb\/c4nBmXFRayRocEQ3akNQrqxZIgmR9Nnz6VFP8rkmZtF8M+Niio+O8Ii65udJRioxz2tyZEJiRrQKEvW3M2VsH85Nsgzk88D0bFGE2rVtYJCZPBBaAiQNKN6gBJQsYjJDTDCdzjlcgNbiVZ+AtESmKDMKTjFXEWyC5nS1CpSARasS2wcTpZpuepjEiEx8E7soMz7xkDi3nz\/RsyNomqbarUyCwySNVBpsDdZaqspijKXOI4iXDPGMEj15MZHWhORUvEyahG6knf+zBnEGrENcsOuRJkS\/5sdJPo3syyIMPdp3Lmjzoy1aNO89a5yIblKHOESS+ujrJni6BJFiUnIrmGDhujCZRMNot3I\/NbJ4mkoUiqiB1uJacG2bmtejjXGyzUnrMfQoVCARtSEahCBbov\/yHeeiyYzXQkDQMVuJeYUPzkQqoNLSrQie4NO306hdrqtgApKmaValWCH0j6Y\/WaEER6Bf8E0i3pyKdIUn0jHgFNpohZE0WwhybJZGcS63DzyrXesQm+2uRjxLp1FIFhCVEydGmSj+yTZqxoIUgZRTvi4RPWinJrx0OdM51a4nwyhFm\/itYBRlewmRY8RDFGGjCewbwQC\/YpwGI\/m1DG3AWRKttNtKoxq88zQRroygOAfGUBsA5xtEHUydJYTaEsLtTOIOMhTmrhdsBKJ0NTTyWhM4mvJ4PzKya5omGYoIpTal0Rzmb3mmNJyC3SgCiLhABybgqQluiIFfkb9EbQk4ZUarsdLYfQamNpEXExAXEerMlGDHi3ig1INkoDUyOt\/rmARldALRohkuzV3OQ5TWFKY9ektFA1N2zzczUTc1v3qkDigK3E43beKV5kTYJOOvw4kslJ5+YiTHAkww8ZMOLekTAqva2+TOvYxfmDAyWPoBWozgIjMjAxWjokM3WAQfQGnzmX2j6SEVzW4RaKUu4f9JhYgYmgfopRvmRxgnaK4mQuFgTLjeYUae0vTOfUDS8b3dPpJNuEinhVH0izll0UA8EzXBAMSUfkR5nWJk7Uv03CZKheK41oqCTKlt\/146scGsxiF7AJdI+4++xOohy7vKtPaulYJlkrM2WdDTwNmUJrqmPI8Cz2jpCjwKCHN7g0o1ekw0WMJNYyYNliUpdVYSnv5SE12BKP8SsKbsq6tFvq3PfazuT3+8lASj+liLNf4vw5LxS7AWhMjM6kCmWqDmyjBrUUnjKnx1oq4FXzOlwJEJ+Ko5MYb77r2vM4+hziYsOmAlCEmLJkh1oQWxf5ZLieF69B1dVQwS7e\/r8DwOa4IiK18YpX8zAQ7XtBZH\/DJuAZCeRF\/poShmYuzSMSPlabqglUA0IhruOLC6DprJ5ejGSFjFUMJXTN4z4FeE4yb9zIRr3XZa5jdvbibMEQS1bNtBZnPwXwyxicC+8KjK+Lz4iOYFr3Z7dse0KQC5giDpitp8zZ1fPGbTkXgKTHvfu2FnrlXqlOPK1lM3b7MppB14rnzEF2vTv1oDoboAYDoFYtlclFJIm+N7idcLAmoh0bF1GbKLapq79RlRMsCgydhjZExxVDqQsyAXzg0hmy7m6a\/kZMASzGo+o+7HkMXom+qzdFklxAnIyI80tsY7fvcw1O\/9579E247ZGK2zfnmF1ZVFLj5\/kgtnj3PhzFFWlp5X5SMTbHeZeIoaXdTVzJiSE4XiRz4JZfGgwEnYufMqbnj5DezZs5vd117H1m1bmZ+dYzg1pK5rqqpSlSUdtkQWCZOULuIl4nAitG3LeDzm8vo6y0vLXLx4kRMnT3L02DGeOXKEs2fP+tH0YB24Yx05ld4CxRJ7J2lpLISo6pcJUbDEaJhIoyCYoWG97bpXJKUyxpfp6hrGG7B0cZWzJ57kwH2fYHXpAhfOHcM6i7F9x5wUME1SrhUq4VHMU+uKsa+SWOcct992K+\/9B+\/h9Te9junp6T4X\/i8eyysrPP7El\/nIRz\/Kgw89hDGWiUYvRDyJgSqvnFyXzrRjMybHgE9XhfBVMHPXo05ieS3393Jja8Nw6Bl67KlHuOfPf4uVS2eVhKWxPEO6ibQyibF0JiJ+IVlJU2S8v+6Pa3ft4sfvvJPbbrmlRBbCUpfR6VrRQiRGuwH54BZ83\/RfJlMcJFwu5lDD6ONLDzzIBz\/0IU6ePp0Y1g2b+4l+TjO09SqZWGCaGBhTivvuvY9v\/KZvVP0EayTHVxLCvrhVoW1hbcUz8ZVvuIXv+qFf5NobbgarzIkkfUoIpNxIZSEeSFeYgwhg0jwRcHDbLbfy4Q9+MDOwW6kx6lOpu5djFb2ZTNTEtiJSNmowyQxUjNDDaBK\/5c23818+9Gvcduutyd2IKduUa6X6UDQvoC+vpHNRf9mOJh5YTK4AGsn5igi5lAYsLwpzW7fwzu\/7Oa674WaMtUnCi9XnQAD9LyMV5zdlThD7GMNtt93KL\/\/7D7BlYYG01NXR+n5CZiIP8p1Ou8jsIkgoPvIYuU8UAsXc1EfYtm0bv\/KLH0iMjEm6xifJSEcbk7ZyBUeWyom3bdpgpE1c7p3lwhjWLwv10PIt776TuS1XY22ujHQrKfFIYtAr0OY5YqCw65pd\/NxP\/WTqZ4ztS\/GEITK\/ZNN2OdFXN3V5UaQ\/thaezrgRS2srfvanf4pdu3aFLhOqVUV1KYt2r4xWWInuhGaT+2Cdg9ZBi6EVQyvgHLQSrjtox\/GaYXVVmL9qK2\/7jn9G61pAcilKIV+CEFAItj3SLPoB54S2dfzEnXeysGULeiFVWboJh2JCOJsQZvTpE311odHqvCsLLzC\/iLB92zZ+4sfu9O4ijKUtUgdIPXJBs4lzBO1NIylE0nYNh19590v+MA6Mcy20TnDi9zzFaw5YWoRrX\/lGdr38ZpV+aNyyGSq5UWqCjkZvv\/VWbrv1lgRcb5yJNFSmOvxfwqE\/vU3JrngCw0Vr9ZXNH2F9y+23c2syq5SMVCWmGEEkSAq3okyt1uDYZAKjjTHY8+fO4DBB8wIzkxb64KYV8d8F2rG\/JhW89s3fTdu2ys5rAPRMfUpEv+vE4cYt\/\/C97ykIHyW6uNg57bnGLoo9ATIFKAY4fe4S+\/\/mHsajdeW\/Xur8\/uL3vfe9OOdyE+X3ulo0UTJMglCBrRiaPsvr9q9\/92d48qHPMm6DtjkYt1KYVNcaXNROPJPX1mDbNTcyu3BVAi6tFigNlAxdD+l4etXVO3n9616nIO9oVIwsJuGuotNyaOld6mresQsjfvnffohP\/tiPsO\/D\/5F2tJ5avrT5\/fH6193EzquuKnuWqlSSAZ1WaOYF4zmhamQAY22xL8qa8SL3f+xX2Pf5jzB2hg0HzhnGAtIGpgaGjqO\/bGG0AVPzsyzs2JsdB0pqOhJVAK4QMMbwipe\/PCXyXS+XrpmSCWmMrpab7on2r3mEkYPfuOs+Tn76j7n95nnWHvwUX\/mTj\/YI+lLmn5ub5YYbbijSKzp06BGjezP2jb7QZMZ7eQjXrA2BpcUOh9MszM3w0F\/8Bs88cT8i0LberI7Fm1InJJ\/ZBi11znv7+e3XZqj6BjuZgChVBZOMN6l791zv7wlF3hfJFWVkwgibuqsOdXrnf7HvOb74iY+zVy5ww7uu5Zo7tvLsH\/0el77ydKf\/lc0fFWrPnj294nskfjZReqSyTQz+ykJBaVKtMWnt1FiLHbctzXBIJWO+9D9\/m\/XR2PvCaD5bk6NU8RFq62DcGkYjmNt2ba60KLvVNV1FtUibOhGu231dJkj4T6c5ZS9TEC1fn2BSA1BdWE5fWuGjn36AwRN\/wzXbhkxfO8XMjXPUo4sc\/dTHOq2vbP64ReT63dflvFvljL2j0FStnnrtMDOuu+BujcFWlsparIijshZTVTx78AFOHz1Ia3yQ0zoV5ART6tp4Lowd1MMtKSlPpbWInEhIIVyu1qilrxjYbNuyxbfXVrFbrdYWyjfo0MP0703YRwrw+391iMP3fZEdSyfYsX2Getpit1fMXT3kubs\/x8qpExOJfiXzb926LRRNFOE3OTZbi9Qj57RM\/QVzWlUVVVVhh4Mpxm3L4uIyi+fPcub4oeT3WvFBjoSgZxyu+Xs+SrXNrN83KoX4J\/lX1bkJQPpjbn6+oIuODIulpxcgQDlmdGB9Iv35I8f50\/ueYvrZh9law8LcEFsZ7HTN7M4pRqdPcPq+e\/O4L3H+hfm50op0qlJl+KuuqaYmXNdBUb+gEgIlY7Btu8HxEyd47swZNsYj2nFLKgA4cOKDnKiVLn62wngMphomZIOCUdRGFT4F+grg4XAYvnTDGlGS3I0YS6p2jZ5ER6bafPn4JX7zM4cZP3eUuXOH2DI1YHam9slvDYNtNVODiuN\/9knGl9cCja9s\/ng+GA5LifWDZA5JVxiyAU0mWFVntGnNfzaM55XHPnnwIF\/5yjOsra5ijME5x4bLuWHMG53SxnH0jQLGVHkdUCSZzPJJqS7kwQBZv8+1rmuFUhSF8D05W1PcKRhVUFIbtyz55y6t8quf3M+p5xcZfuUB5jdWmBnWDAcVrLdYJ9SzNVNzA5aOHOL84\/sVc158\/sijuqpDDuwmeOMe93TY2WOUsRM0MGoo0R0J9viJU4w3xhjrRxs7cOOcG3qTqnyijlQdCJX3eS77u\/TMovKBea1DrXoELtdVnQjm1ylNwUfNmH6smSO9pCsd2h05fZH3\/8EDPHTwJPW5IwyOPMz8wDIzaGjqGrPiMKMxdmBoZhtYW+PMl+5\/yfMDNE0VLLkNKGo\/0tfBrItMMJ0++uwyMz7Q6pzDOaEeDBo2NjZoW8HgaMcj2sAIqycMQi4GbAhKqjYQTwBxOLHFqklaJ1SgT5JNq5xBfrpKt1bzdwgZdcTomwbEOY6cPMuXDp7hI\/c+w+Fjp5gyQnXofuY3LjE7P8XUoKK2BllpYdlgasNwxtI0Feceup\/1SxcZbtmqJ3rh+RVTEQdUuuskY1Qwtb9XtRPhdjpFI1E714bo0cvxxvo64zbIRusfIs05EuHRNH+4oDkijlYqbFyhJzMvC18XDRWya54VgJre5S7uvcgUWFl3\/M5nnuTP7j\/E+aXLjC+dZnrpOepmisHRA8zXFVO1ZTisqSpoVx1m2T+n2UxVNMOalWNHWTz0FDtvf8tLml8TXWQSszq907jlioe\/VYpLXlJUimHAiiujg7WVS6kEF6s2McjRpblYyQnPhU4GcNPr2YQoY7JpF5Od6wt5GTCwNHL8p794mj\/60knOX1yE008yfewx6uVFzOmnmVk9y9zAMqhqhnVFZS2sC7LqKW6HlmZQ0y4vceaRB0qwXmh+RVWDt2QpRi+id9XOZOalFQljJvpCLendkWqnVhKcc8zMRN\/n80dnsqxpN+WASsClyCojkCfrG540irI+3ccPCIhnkdTmthxNH6PRBv\/h9z\/Hp77wJM3yWZoLp6iWzmFGl3HXvYbmyKNsqR1Tdc2grhg0FmOgHYFZ94SuBpbB0FLXltOf\/yw3fv\/7aGZnX3R+MfmJLJ1eFQ8BRO1KaUWskZbM9G1NalYUSYqUxV+qY5gKYLG8\/KY3INYjhjGl6BnCZh9\/tGOSavf54GeIS1XJTCRwMkApb9YDqTKdFozomIwpbzqB3\/vdu\/jL3\/pDZt0IM1qH0Rp2Y53x1l3IhVNML59ldqZiYGqapmIwqKgsyEiQdfHRW2NoBpaqGbB28gRnH36Aa7\/lHS86f9+aiO6RLuU9QbnIrf2fLreZIMT+8cJ4rlXBn9Vt69V+Y\/0yN731W7n5m76dpw471sfiS0mK+CU\/xWuhdJlTWJaAcOkzookxFoxTrx\/oEIbyVFMsfY5b4cDxRb7w+HP81YPHaZbOYxfPYkyoEmFxC9sZPPsIW2rHdNXQ1IZhbWlqA2KRVnAbgSyVoRlamtqyvrTKqXvu5tq\/8\/bwtG4QLOPxn+Tw8qLEJG9dgJ4+N90JoPNFiZFu0GTJlK5FWjZGl9n1qjfx93\/0F5ieNwymDMvLY6yrsjXrRsexYoMB\/DaNZCmN3llGcZ4w1XaisFHdWC6cq21tApy+uM6BE8vce\/gih04usrGyyuwNNyMbI5bv\/VPk7FGsjBldfzOsLTGzfIb56YqmsgyCOW1qi40P0Y69\/ze1UA0rmsZQ1RXnH32IlTMnmb3mujR51JBSy4LAF2\/N0DTrxa+kiLOTWmRTquw3wUH1ItTwkOnr7\/g+7vhHP8POvTfQtrCwAGdOG2ylAIlKoMypE7DkR7fT5qliEtI2waK4L91WcY4eqkRnNBo7Dp5a4UtHLvH4yRXOLa2z0QqmdQwrixHLtlfdzNRwigv3fJzRhTO4q\/Yw\/cTnmG+E6cYwrCrqyjIYVNR15fFzIG2QbmuxA0vTWKq6YfXUSc4fOJCZWFgJLXAqLlDMoONK9KqOSXwsV3u6uwN0ojYpsKrf\/a\/\/gOvfcAfDYcV47P3cli3gjDBuBWtN1gttj0OEmjGK0jfpPRPZQyQhUEB3yq6hsx9lNHacWxpx4PgyDz67yLHnL3O5dSCCNZaKFmfIz7aLY\/plu2ne8R6OH32G6uB9zI2W2DJTMTSWpjIMm4phbWgqn1C7FszYJZCqgaEZGurKMFrf4NTdn2XPO79zAvmi385VFE0Ob7BKhqS4JuV9wQf2otHohkRFfmUmEb\/We9\/4rSD+1SStwEYLMzNQ1RUb4\/CwRpzcJdoi+PYi3WpC1rzCTsZddSYm5r6YoOUgmV4lBkfPX+a\/332CExcv+9UWBGuMZ1xYHTFOMOIwYcO+AdamFmiXnmfm3DNsGVqmG0NdVQyqmkFjGTTe7yW\/LZ7QYg000AxqqrqlqivOPfowl555mi03vDJpVp+VHQ6qoCW2mbS0pIOZ9JcYqLilzVhwXbEiZo04XzExYaPUBlgLC3MVGyNH2zqcC\/miwJhcDG9bP6Z+INRuAmQv+pqUA6UNV9m\/vnLnNO998zVcv32KVoRxjKZFaMeChMAM58D4\/mtiOHvkMM0TX2BrJcw3MLAVw9qb0WFd0wwqqtpgrSSC4BzWgKmt18ba+8X1s2c49fnPBSHMLFPpa0FgTQt7JTTp\/tNSEXDtO6l82IU5w2Dgd323DkZjf2NuAcYitM7ghLSSkbZstPnNX4TkNO1DjcmqNcVekARwkjzlaAPzdGQrQSLfdP08d\/7dl3PHjVtBYNx64RIXzKoLWigwaoUzJ09gH\/4zto6X2DYQnxdaH9QMG8twUPk8sbKhZoz3iwJiwTSGamhphpbKGuqm5rn7v8jGyrLSOokKUbjy7lripKizOJJbKS4SU7+ibJllvUj5rcEwNwVTAx9Fty1sjGBh3jceO\/EMC2uMiZnhe9QqmxjX3VBM55zEyOQWVOrQCWeI4O6cb\/jhb97ND33zbrZO1YxGDtc6rDiM8wCO25bnzl9g\/OCnWFg8xvahZbquGFaWYVMxNWyYGlRMT1mGA4OtbSBsfPmEwYgDtwG2pbGOygq2qll6+hDnn3hMKYIndIJXaaK1sXBtJ9Cjq4XRiiqTqjWtVPN8UacYS8vCoIHpaWisF63x2H+3xviEviqlwITPWgAxacNON\/z1ZsBQroKH7xI0tYhodSoRZbyU3rffuI0926b4yP0nePjpC5i2ZWO0ztrqCotLF3D3f5ytJw+wszHMDSzDumaqqphqKqaHDdODhqlBzXBQUzcGUxHUB2Q8oprdycyNt1BNX83yU0e4\/Pm7WT91ltHyiNP3fIGXvfltmRYaNrWLIOJlrS88x+coEy5KuPsRoKhXZOZHLDIj9bqtP2rXGtaDS5mZCY+1tdAMoBlUrK62iLUYl62fC0yUFsRKoXH90ETnFSYHNpA0V7M4E0hrYsnIV+yc5ie+4xV88oGTPHj4HG\/au5NWHH\/1u7\/D84e+wM5pmB965k3XFcNhw+x0w8xUxdysZXqqYjisqeuQFgG0LbOvfTtb3vb9DHbsBWDHt8P2d36ZJ3\/zP3Pqi1\/gzD2f5\/IP\/CBTO3ZqvmXYA7SViS\/RM4qBdJjYjULJMiwFRVR6MXmFsnYimNawYWB1zZvU4QBqC9NThktLgA0FCxcn8Z8tZVroeVhqXmRI90tyi2oHlWaXSRqpw+sc\/Q4by3u+aTffeevLmJtqAPi263+U\/7FykKP33cN0VTPdVEwPGmZnBsxP1yzMNsxM+7\/h0GIa45+1FMfCLd\/Ntjveh62nFEIw\/+rX8caf\/yWmfv2DPH3XH3P8s5\/hVe\/5x4pvUjjGHBtoyyTpXgzkkhsx2daktVd1DYN6p2wukUZhAL80GNMr2jFcXof1kY9Up2f8FsU2rFikfachMnVtkBLtuCc5855\/VGJm8mNyZmIlfIKfNFkiIwMBdr3iBn7gA7\/ItXv3MlNb5qen2Do\/ZPt8w7aFIQsLQ7bMDZmbqWiGBtsYRMYs3Poudrzjn5YMVJI3mJ\/nph\/\/SV79T36Ek3\/9l2wsLao20bFnRpRROsm0Rv\/o44f4glpTTDlxa0u4PvH9AsZgnTN+jdBJyhNH655hw2m\/ZdGNJa\/qq01UTkDatmScLaOzIv2wKgCKAY6FNuQqxfN9+jwFEhMYWzh+eNmrX8Pb3\/c+ti9Mc82OIbuunmHX1bPsvGqa7VuGzM7XNNMVdlAjxjH3Dd\/Kjm\/7EbDqraG9+YVqMOSmf3En13\/nd3HxqSczEJ35x65NguZpbNJGX\/2m4R6T9J5OU17v7mPtPhZfx5fvISZVYUZj2NiA2oStiwImRqJB3SVEqRhXaFp8T6cngpez+FB0V46MNVgs48DE7ivHTEysdSgfosjcSFE8XP6Gd3036w99muHoPHMLQ5omaEIVxrMg4w2m9tzEjnf+MKYJG7WkM3SaP\/v4ve\/6HkbLi9n0d+Zvx23ia8qgOqlFd+u+FMzramY+L0\/yUYuLfiG0cT46FWB5xZvRSkgPoPpJSVGutCMqG3JDyvwlusj0LTi0nGL4m6PRSOOkqDihhDfB4ma++tZz11zH67\/nu1h84A+xM0MfPIVk1zlgtEG1fQ9Xv\/tO6oWrM1JdDZkwv6ls3rLRmx9G6+sp+ozweq+RV28ypJpQ\/qSIx4tEP\/jL2FMBVSepsX4cB9QVNA0cOe7Vz7UGa0OJTPL43ryuKIZkJ28SZNq5k1OIEChZW7GysjKBKxm\/roZ0G+Zbmehb3vL32Fj8G9x4CcQgY3DrDrO2jpnfwc533clw1yvzUHqCr3p+WFpeDn5NBS3BmqSXYMgk55CZm\/5PplQzsAMgUKs5EAf1EHZfBw\/ug+fPjxkMB973hSJnipgFqgrc6lLAMG9RLPJFZb9Tjhi\/Wf\/90uKlBJtol6HM6cSjszylNyw1W\/cwe+ObWT\/51wg1MnaMVzYw87vY9rZ\/yfTeN\/W1\/GueHy5dutQJViS9hDBhbkyv6uKnk4KO5UvuKaENAZQYE19G5AOV7Vtg97Xw4H545PF1BgP\/pv4WMDG9CL6xFZ+KrD13isp68kUJ0kzUJiRKZlrbxIfHJ06ezAhHP1GMo8itKd91jR1qT+2+g43z9+Lay1jrGGx\/A7Ov+UEGO17jW8ex4qfi11c3Pxw7cSLjTXj9ycTsThMoMjQysMu8CUeM\/PGxC3PzcM1OD8ln7obDz15mOGjAWJwYTKsVPlhCB42F9aWTYGzGKzn6\/AqRIplFvd04OJMTp06GvplopZEyBaF7RDCTidxsuZF66+sYr5xk+ppvYer6d2Ob+dxsAjO+1vmPHT+e5SKaz4RsbBbNa3hJcIw+FQP7b0uOfCtTN4D6ptfC8irs\/zI8cWjE5Q3DoBkgJrxB33jfZ4x6eZbzEbkdXWb10lHESSp2i2Jg5HpiTgI8q4CIcPTYMVZXV5mZmZngZTLBux7WQJkYdxhiqmnmbvwhsDXV1DXFmIXBkxyIfC3zr66tceTZZxOdSiukJtCaKdn3ReXb7H1zov7SL+EYqD99Nxw7MWI0Fpq6pqnizmVDq9TPBJ8Yg5uFBWguH+byyvm8g9sby\/SW4Ch0UYQNFL9O5Zx\/6cKFixc4ePgQt9z8xolrkSZogo5AN1WizlHN7O4RIg4TGVCM+1XN7689efAgZ86exVZh07AIOgqPTC1SDMXA\/pJTKTSRy+WucrCHjoxppaJpBpiwH0NEP58Y\/lx8BsP\/bZuG81\/5U+q68mW5SRSNChirFGrJysaXzFpDZSs+9olPqD7\/555PTOTsxStGfby0+eO1j951F1Vd56Q+dEp5fGSYSPiZify4X3pJkxrRxP90yqLgifphm6bCmArBrxtGJsUNwhLPJSwaj2HHdphbf5yLpw8AYRu+tT0egpR2nCjDpuOQhP2PHeDRA\/tzv65J6RL9q3k+MTHXdC70I8Urnj98PHrgAI\/s3x9wtV7DE8MnMCxGngqCcr48QqJcJB26Imb9y4gEkLhGGMpqkaFpLdH5ktz0NFwzWOb0\/t+mqSviq5vLyTPjJq\/qk9p4bayo6o8fkkQAAAYfSURBVJpf\/63f5OKlS2gm\/+96PrH4mpRE+e1e2yuc38Di4iIf\/q\/\/jaqqk4UpymsiiIvaF81hz34kwDR9ujsgMgNVLZYQsKS6pQTdiCYAcMYzdnYGXrUTVg5+mNHaOa99Rv1IR5wg1go71fyuf4i11cpWWGs5c+4cv\/qhX8O5\/ORxGbF2DkWBrtHrPp9Y9C1WAvoD6rE2mz8yV0T4lQ9+kDNnz5RmtDO0hLbp13py6BPaKgaa4HrSwnJnXOWaMOFdfAg6B\/cEiEIUApqX7YRX71hi+bEPcPH0fsCrcpeS3rKWhe4IXEaG4vDMsoBh34HH+PkP\/DsuFkmzj0Ky\/IarKdDQpNLG1WRa9dbMVK8imdazKMlG\/46VJ\/Ti0hLv\/4VfYN+Bx7C2wsbtHqbz15vH45yn1X4vaJwxqrv210kfszWLmh0XeuNz+a71FZlt2+HG6+B6+xhn7vtpLp4+gKkqrE063yGM6fwFkGPoHNfFgpZoklnrt0vs23eAf\/XTP8Uj+\/blMZNPCj0SPfRVFXToQEHBGecr8zCTxpz0fKRmcdSI\/Y89xr\/52Z\/lwBNPUDc1VXAtpFn6R1nJCh+FRJtEtih35QKG8rHkjLv22zCCBhlfM52dgqkamnaNweWneH7fn3Dy5D4Gg0GIvrzW6BQoCkzHFSjC5TA6Ez4\/rpWeB6ks4hxnzp7jZ97\/ft70hjfwnu\/9Xl77mtcwNztb+CKtT8W5yazpEbJspC4qQTHdPv7C2toaBw8f5q6Pf5xH9++nbpr08gMnQjseF3txI9OcFjplRfV7Y\/O82WSJCt60zCa3Zz0e9StmnsHSghth2hXk8iUunznO2tIxzl86yuXlc1RVTTMYYOvwtgYbzUZpJtV\/4VoZgZlAvEL4itDam2ipa0zroBb2P\/44D+\/bx47t29i7Zy+7d1\/Hnt272bZlKwsL8wyHQ+rKB0ZZU5T\/MGr2SECjYVHwOsG5lnHbsj4asbqyyoVLFzl+4gTHjx\/n6LFjPH\/hPE0zYDAcpgBGIO2k9kUBny\/HQMbzsIxmNXAmnYvmocaC+BO8aTE5Bi5AffgvfxxM2Dta5SAkOum6rjHxfSm2ylv86AlsMpEZkmz6Sjeeb0e+S0hHRPzczhosFeCoqpoLFy9x4eJ+Htm3j9b5nW5xtTs+YykdIepHd6DLVfGwKnCIEXTEt6rUbjVrGTQDbBTkqGml+oVqisdYZALz9BEjdiaGbmjzEIW0rE0Ldd14CUYjEhvbHC7HlekXPJL4bAZx2bT4lkxzfgG6jZuYMLjgpyQ8sCLWhn2v2kyDiFPaZlW0Z7OmmrxQ5q2JzT9RaAzW4B8RqKsCDmtDXha2V\/j5+klC93etpPepfl0u9jIUz7mkm9rqqzQtkswI1FUVn3xS4b9I54W0L8yQzY4XZ+WLH2mfSvTDzv\/qtYiox730p1VMzKH4RCZ6tcdiSTGJmk9rIRBo0glQXhDPLvte+ChMaGlPJ+poPOqCUUkTzYSO0rvyYsckE\/q1HskHKWj6mxrJTNQmlcxE0jmloKbQvuyXbH1INXpxUYKFjjoJm1GixzR9zZSN8sz9oWrNwGgutVvrAjhByzMyKcozXWz6bYu7npi5mrFJY10gTqY026Be3wL4vLLSJVL83YkcLHjblrQ7NjdZVDZbaUiDBqBMYL5mpelSVSie8Sgn9bClUVO1JwtX1kSrmNjPxoP9DQN2eKQjQC+5pqCUjlL7ObePvOIvfoOKVqP2KGJOoteLBg+6bafmmYicKBwDkk7kKv5pLLHx57W6i705mNPVroyrmcD4TM8sidE6dNoFGN761rfiJP7KuncRda6s9KM2PUgncida30lmJWuZjrkC0tpMBFLk6kRY2yOayMl8ifKRCwiUIbyh\/El2jQf5F2Mg9guDGZNMluBwzhLfnhjNeNbOvAqPGklfK1CdeCjiJR+R7V0BYxSMZCly19InJhPQdd7ad+TykOkAEZ9l78dl3jyl9oUziL6q45vQFiGTI\/unKEgmMRKl8RNJFgMiZb7jPEXYLgTmSXq3aATbOf8uAwkN06d\/qU9wnVEMS49YaKLJ8E8gYqKJv2zUaIoPYfT\/BXBA8FlZcDz1AAAAAElFTkSuQmCC","width":113}
%---
%[output:14e2a370]
%   data: {"dataType":"textualVariable","outputData":{"name":"ans","value":"'\/Users\/brian.bingham\/WorkingCopies\/ae2440\/lessons'"}}
%---
%[output:038f336b]
%   data: {"dataType":"textualVariable","outputData":{"name":"current_folder","value":"'\/Users\/brian.bingham\/WorkingCopies\/ae2440\/lessons'"}}
%---
%[output:5c3e191f]
%   data: {"dataType":"text","outputData":{"text":"\n.                                    ..                                   Heron.mlx                            batt_fit.mat                         euler.m                              euler_rats.mlx                       heron.png                            heron_villages.png                   heron_villages.xcf                   lesson_anonymous.mlx                 lesson_anonymous_lorenz.mlx          lesson_anonymous_pendulum.mlx        lesson_beam_ex.mlx                   lesson_beam_ex_soln.mlx              lesson_conditionals.mlx              lesson_cooling.mlx                   lesson_cooling_soln.mlx              lesson_curvefit_regression.mlx       lesson_datatype.mlx                  lesson_datatype_verbosedivision.mlx  lesson_dictionaries.mlx              lesson_fhandles_fzero.mlx            lesson_find.mlx                      lesson_find_cmd.mlx                  lesson_functions.mlx                 lesson_interpolation.mlx             lesson_intro_ide.m                   lesson_intro_workspace_path.m        lesson_loops.mlx                     lesson_matrices.mlx                  lesson_ode_intro.mlx                 lesson_optimization_intro.mlx        lesson_regression.mlx                lesson_secondorder.mlx               lesson_system_of_odes.mlx            lesson_vectors.mlx                   massspringdamper.m                   plot_stress_strain.mlx               rat_rate.m                           rate_rate.m                          rr2dd.m                              \n\n","truncated":false}}
%---
%[output:7aa162e7]
%   data: {"dataType":"text","outputData":{"text":"total 14728\n-rw-r--r--  1 brian.bingham  staff   148K Mar 30 17:55 Heron.mlx\n-rw-r--r--  1 brian.bingham  staff   8.6K Mar 30 17:55 batt_fit.mat\n-rw-r--r--  1 brian.bingham  staff   1.0K Mar 30 17:55 euler.m\n-rw-r--r--  1 brian.bingham  staff    45K Mar 30 17:55 euler_rats.mlx\n-rw-r--r--  1 brian.bingham  staff   107K Mar 30 17:55 heron.png\n-rw-r--r--  1 brian.bingham  staff    98K Mar 30 17:55 heron_villages.png\n-rw-r--r--  1 brian.bingham  staff   174K Mar 30 17:55 heron_villages.xcf\n-rw-r--r--  1 brian.bingham  staff   817K Mar 30 17:55 lesson_anonymous.mlx\n-rw-r--r--  1 brian.bingham  staff    69K Mar 30 17:55 lesson_anonymous_lorenz.mlx\n-rw-r--r--  1 brian.bingham  staff   114K Mar 30 17:55 lesson_anonymous_pendulum.mlx\n-rw-r--r--  1 brian.bingham  staff   118K Mar 30 17:55 lesson_beam_ex.mlx\n-rw-r--r--  1 brian.bingham  staff   107K Mar 30 17:55 lesson_beam_ex_soln.mlx\n-rw-r--r--  1 brian.bingham  staff    74K Mar 30 17:55 lesson_conditionals.mlx\n-rw-r--r--  1 brian.bingham  staff    60K Mar 30 17:55 lesson_cooling.mlx\n-rw-r--r--  1 brian.bingham  staff    86K Mar 30 17:55 lesson_cooling_soln.mlx\n-rw-r--r--  1 brian.bingham  staff   429K Mar 30 17:55 lesson_curvefit_regression.mlx\n-rw-r--r--  1 brian.bingham  staff    11K Mar 30 17:55 lesson_datatype.mlx\n-rw-r--r--  1 brian.bingham  staff   3.5K Mar 30 17:55 lesson_datatype_verbosedivision.mlx\n-rw-r--r--  1 brian.bingham  staff    52K Mar 30 17:55 lesson_dictionaries.mlx\n-rw-r--r--  1 brian.bingham  staff   295K Mar 30 17:55 lesson_fhandles_fzero.mlx\n-rw-r--r--  1 brian.bingham  staff   148K Mar 30 17:55 lesson_find.mlx\n-rw-r--r--  1 brian.bingham  staff   3.6K Mar 30 17:55 lesson_find_cmd.mlx\n-rw-r--r--  1 brian.bingham  staff   250K Mar 30 17:55 lesson_functions.mlx\n-rw-r--r--  1 brian.bingham  staff   322K Mar 30 17:55 lesson_interpolation.mlx\n-rw-r--r--  1 brian.bingham  staff   4.6K Mar 30 17:55 lesson_loops.mlx\n-rw-r--r--  1 brian.bingham  staff    24K Mar 30 17:55 lesson_matrices.mlx\n-rw-r--r--  1 brian.bingham  staff   2.8M Mar 30 17:55 lesson_ode_intro.mlx\n-rw-r--r--  1 brian.bingham  staff   165K Mar 30 17:55 lesson_optimization_intro.mlx\n-rw-r--r--  1 brian.bingham  staff   467K Mar 30 17:55 lesson_regression.mlx\n-rw-r--r--  1 brian.bingham  staff    40K Mar 30 17:55 lesson_secondorder.mlx\n-rw-r--r--  1 brian.bingham  staff    87K Mar 30 17:55 lesson_system_of_odes.mlx\n-rw-r--r--  1 brian.bingham  staff    88K Mar 30 17:55 lesson_vectors.mlx\n-rw-r--r--  1 brian.bingham  staff   325B Mar 30 17:55 massspringdamper.m\n-rw-r--r--  1 brian.bingham  staff   4.8K Mar 30 17:55 plot_stress_strain.mlx\n-rw-r--r--  1 brian.bingham  staff   191B Mar 30 17:55 rat_rate.m\n-rw-r--r--  1 brian.bingham  staff   191B Mar 30 17:55 rate_rate.m\n-rw-r--r--  1 brian.bingham  staff   233B Mar 30 17:55 rr2dd.m\n-rw-r--r--@ 1 brian.bingham  staff   3.0K Mar 30 19:48 lesson_intro_workspace_path.m\n-rw-r--r--@ 1 brian.bingham  staff   2.0K Mar 31 09:20 lesson_intro_ide.m\n\n","truncated":false}}
%---
%[output:5354299e]
%   data: {"dataType":"textualVariable","outputData":{"name":"x","value":"20"}}
%---
%[output:672d9c9b]
%   data: {"dataType":"textualVariable","outputData":{"name":"cross_area","value":"1.1310e-04"}}
%---
%[output:267e389b]
%   data: {"dataType":"textualVariable","outputData":{"name":"volume_m3","value":"5.6549e-05"}}
%---
%[output:07c96a47]
%   data: {"dataType":"textualVariable","outputData":{"name":"density","value":"7.8516e+03"}}
%---
%[output:093c0a92]
%   data: {"dataType":"text","outputData":{"text":"Workspace cleared — check the Workspace panel, it is empty.\n","truncated":false}}
%---
%[output:188d028d]
%   data: {"dataType":"text","outputData":{"text":"  Name             Size            Bytes  Class     Attributes\n\n  cross_area       1x1                 8  double              \n  density          1x1                 8  double              \n  diameter_m       1x1                 8  double              \n  length_m         1x1                 8  double              \n  mass_kg          1x1                 8  double              \n  sample_name      1x11               22  char                \n  volume_m3        1x1                 8  double              \n\n","truncated":false}}
%---
