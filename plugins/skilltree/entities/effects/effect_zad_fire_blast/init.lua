/*
local function GetRandomPositionInBox( mins, maxs, ang )
	return ang:Up() * math.random( mins.z, maxs.z ) + ang:Right() * math.random( mins.y, maxs.y ) + ang:Forward() * math.random( mins.x, maxs.x )
end*/

local function GenerateLighting( from, to, deviations, power )
	local start = from
	local endpos = to
	if ( isentity( start ) ) then start = from:GetPos() end
	if ( isentity(to) ) then endpos = to:GetPos() end

	--endpos = endpos + GetRandomPositionInBox( to:OBBMins(), to:OBBMaxs(), to:GetAngles() )

	local right = (start - endpos):Angle():Right()
	local up = (start - endpos):Angle():Up()
	local segments = {
		{ start, endpos }
	}
	for i = 0, power do
		local newsegs = {}
		for id, seg in pairs( segments ) do
			local mid = Vector( (seg[1].x + seg[2].x) / 2, (seg[1].y + seg[2].y) / 2, (seg[1].z + seg[2].z) / 2 )
			local offsetpos = mid + right * math.random( -deviations, deviations ) + up * math.random( -deviations, deviations )
			table.insert( newsegs, {seg[1], offsetpos} )
			table.insert( newsegs, {offsetpos, seg[2]} )
		end
		segments = newsegs
	end
	return segments
end
/*
local function GenerateLightingSegs( from, to, deviations, segs )
	local start = from
	if ( isentity( start ) ) then start = from:GetPos() end
	local endpos = to:GetPos()

	endpos = endpos + GetRandomPositionInBox( to:OBBMins(), to:OBBMaxs(), to:GetAngles() )

	local right = (start - endpos):Angle():Right()
	local up = (start - endpos):Angle():Up()
	local fwd = (start - endpos):Angle():Forward()
	local step = (1 / segs) * start:Distance( endpos )

	local lastpos = start
	local segments = {}
	for i = 1, segs do
		local a = lastpos - fwd * step
		table.insert( segments, { lastpos, a } )
		lastpos = a
	end

	for k, v in pairs( segments ) do
		if ( k == 1 || k == #segments ) then continue end

		segments[ k ][ 1 ] = segments[ k ][ 1 ] + right * math.random( -deviations, deviations ) + up * math.random( -deviations, deviations )
		segments[ k - 1 ][ 2 ] = segments[ k ][ 1 ]
	end

	for k, v in pairs( segments ) do
		if ( k == 1 || k == #segments ) then continue end

		if ( math.random( 0, 100 ) > 75 ) then
			local dir = AngleRand():Forward()
			table.insert( segments, { segments[ k ][ 1 ], segments[ k ][ 1 ] + dir * ( step * math.Rand( 0.2, 0.6 ) ) } )
		end
	end

	return segments
end
*/
local mats = {
	--(Material( "hd/effects/lightning/lightning_arc_sprite" )),
	(Material( "hd/effects/lightning/fire_blast_main" ))
	--(Material( "cable/hydra" )),
	--(Material( "cable/redlaser" )),
}

local segments = {}
--local n = 0
local tiem = .2

hook.Add( "PostDrawTranslucentRenderables", "Fire_Blast", function()
	--if ( #segments < 1 || n < CurTime() ) then
		--
		/*for i = 0, 1 do
			table.insert( segments, {
				segs = GenerateLighting( table.Random( ents.FindByClass( "prop_physics" ) ), table.Random( ents.FindByClass( "prop_physics" ) ), math.random( 10, 20 ), 3 ),
				mat = table.Random( mats ),
				time = CurTime() + tiem,
				w = math.random( 20, 50 )
			} )
		end*/
		--n = CurTime() + .01
	--end
	local MaterialMain			= Material( "hd/effects/lightning/fire_blast_main" );
	local MaterialFront			= Material( "hd/effects/lightning/fire_blast_front" );

	for id, t in pairs( segments ) do
		if ( t.time < CurTime() ) then table.remove( segments, id ) continue end
		local startPos = t.startpos
		local endPos = t.endpos

		

	
		render.SetMaterial( MaterialFront );
		render.DrawSprite( endPos, 8, 8, color_white );

		render.SetMaterial( MaterialMain );
		render.DrawBeam( startPos, endPos, 10, 0.5, 1, color_white );
		
		render.SetMaterial( t.mat )
		for id, seg in pairs( t.segs ) do
			render.DrawBeam( seg[1], seg[2], ( math.max( t.startpos:Distance( t.endpos ) - seg[1]:Distance( t.endpos ), 20) / ( t.startpos:Distance( t.endpos ) ) * t.w ) * ( (t.time - CurTime() ) / tiem ), 0, seg[1]:Distance( seg[2] ) / 25, Color( 255, 255, 255 ) )
			--render.DrawBeam( seg[1], seg[2], (id / #t.segs * t.w ) * ((t.time - CurTime()) / tiem), 0, seg[1]:Distance( seg[2] ) / 25, Color( 255, 255, 255 ) )
		end
	end

	
end )


function EFFECT:Init( data )
	local pos = data:GetOrigin()
	local ent = data:GetEntity()
	local startpos = data:GetStart()

	if (IsValid(ent)) then
		GenerateLighting( pos, ent, math.random( 30, 50 ), 5 )
	else
		GenerateLighting( startpos, pos, math.random( 30, 50 ), 5 )
	end
	

	table.insert( segments, {
		segs = GenerateLighting( startpos, pos, math.random( 5, 10 ), 4 ),
		--segs = GenerateLightingSegs( pos, ent, math.random( 10, 20 ), pos:Distance( ent:GetPos() ) / 48 ), --math.random( 5, 10 ) ),
		mat = table.Random( mats ),
		time = CurTime() + tiem,
		w = math.random( 10, 10 ),
		startpos = startpos,
		endpos = pos
	} )

	self.StartPos = startpos;
	self.EndPos = pos;
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos );

	local diff = ( self.EndPos - self.StartPos );
	
	self.Normal = diff:GetNormal();
	self.StartTime = 0;
	self.LifeTime = ( diff:Length() + self.Length ) / self.Speed;
end

function EFFECT:Think()
	return false
end

EFFECT.Speed				= 0;
EFFECT.Length				= 20000;



function EFFECT:Render()


end
