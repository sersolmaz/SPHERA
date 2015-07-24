!----------------------------------------------------------------------------------------------------------------------------------
! SPHERA (Smoothed Particle Hydrodynamics research software; mesh-less Computational Fluid Dynamics code).
! Copyright 2005-2015 (RSE SpA -formerly ERSE SpA, formerly CESI RICERCA, formerly CESI-; SPHERA has been authored for RSE SpA by 
!    Andrea Amicarelli, Antonio Di Monaco, Sauro Manenti, Elia Bon, Daria Gatti, Giordano Agate, Stefano Falappi, 
!    Barbara Flamini, Roberto Guandalini, David Zuccalà).
! Main numerical developments of SPHERA: 
!    Amicarelli et al. (2015,CAF), Amicarelli et al. (2013,IJNME), Manenti et al. (2012,JHE), Di Monaco et al. (2011,EACFM). 
! Email contact: andrea.amicarelli@rse-web.it

! This file is part of SPHERA.
! SPHERA is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
! SPHERA is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
! GNU General Public License for more details.
! You should have received a copy of the GNU General Public License
! along with SPHERA. If not, see <http://www.gnu.org/licenses/>.
!----------------------------------------------------------------------------------------------------------------------------------

!----------------------------------------------------------------------------------------------------------------------------------
! Program unit: BoundaryMassForceMatrix3D                                
! Description: Generation of the generalised boundary mass force matrix RN, on the base of the cosine matrix 
!              T and the parameter Fi.
!              (Di Monaco et al., 2011, EACFM)                        
!----------------------------------------------------------------------------------------------------------------------------------

subroutine BoundaryMassForceMatrix3D(T,RMF,Fi)
!------------------------
! Modules
!------------------------ 
use Static_allocation_module
!------------------------
! Declarations
!------------------------
implicit none
double precision,intent(INOUT),dimension(SPACEDIM) :: Fi
double precision,intent(INOUT),dimension(SPACEDIM,SPACEDIM) :: T,RMF
integer(4) :: i
double precision,dimension(SPACEDIM,SPACEDIM) :: Diag,FiR,TTR
!------------------------
! Explicit interfaces
!------------------------
!------------------------
! Allocations
!------------------------
!------------------------
! Initializations
!------------------------
Diag = zero
!------------------------
! Statements
!------------------------
do i=1,SPACEDIM
   Diag(i,i) = Fi(i)
enddo
call MatrixTransposition(T,TTR,SPACEDIM,SPACEDIM)
call MatrixProduct(Diag,TTR,FiR,SPACEDIM,SPACEDIM,SPACEDIM)
call MatrixProduct(T,FiR,RMF,SPACEDIM,SPACEDIM,SPACEDIM)
!------------------------
! Deallocations
!------------------------
return
end subroutine BoundaryMassForceMatrix3D

