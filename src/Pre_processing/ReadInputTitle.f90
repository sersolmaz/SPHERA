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
! Program unit: ReadInputTitle                             
! Description:                        
!----------------------------------------------------------------------------------------------------------------------------------

subroutine ReadInputTitle(ainp,comment,nrighe,ier,ninp,nout)
!------------------------
! Modules
!------------------------ 
use Static_allocation_module                            
!------------------------
! Declarations
!------------------------
implicit none
integer(4) :: nrighe,ier,ninp,nout
character(1) :: comment
character(80) :: ainp
integer(4) :: n,ioerr
character(80),external :: lcase
logical,external :: ReadCheck
!------------------------
! Explicit interfaces
!------------------------
!------------------------
! Allocations
!------------------------
!------------------------
! Initializations
!------------------------
!------------------------
! Statements
!------------------------
call ReadRiga(ainp,comment,nrighe,ioerr,ninp)
if (.NOT.ReadCheck(ioerr,ier,nrighe,ainp,"TITLE DATA",ninp,nout)) return 
n = 0
do while (TRIM(lcase(ainp))/="##### end title #####" )
   n = n + 1
   if (n<=maxtit) then
      title(n) = ainp
      if ((ncord>0).AND.(nout>0)) write(nout,"(1x,a)") title(n)
   endif
   call ReadRiga(ainp,comment,nrighe,ioerr,ninp)
   if (.NOT.ReadCheck(ioerr,ier,nrighe,ainp,"TITLE DATA",ninp,nout)) return 
enddo
if ((ncord>0).AND.(nout>0)) write(nout,"(1x,a)") " "
!------------------------
! Deallocations
!------------------------
return
end subroutine ReadInputTitle
