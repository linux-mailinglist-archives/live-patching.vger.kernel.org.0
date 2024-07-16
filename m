Return-Path: <live-patching+bounces-395-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2369322D7
	for <lists+live-patching@lfdr.de>; Tue, 16 Jul 2024 11:29:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1821B22E28
	for <lists+live-patching@lfdr.de>; Tue, 16 Jul 2024 09:29:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9239E195B35;
	Tue, 16 Jul 2024 09:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VTnilfcM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Qg894UjA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="g7ijDT7x";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Y3NbvLg4"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA3341A87
	for <live-patching@vger.kernel.org>; Tue, 16 Jul 2024 09:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721122147; cv=none; b=p7lcuSDZqTp7s8P85+10fsO4YTl9xA0YFSoDFHZuJaOJKVMtWYuW7GLzZ8Ai8FIAvS/p5+k1rGObBosaPQ3EeN2t42GyQNdDzvAJKFCiUmJCUKO4U6khVMk7ErUm23aP70cC1UM24hRLsUDGy7duCaAitBGQMuPyapg1hlnOBv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721122147; c=relaxed/simple;
	bh=fFnCHjcmDFxV/P+tNthkJ3g4vaHxwVXJU4W0xbCczKg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JPDDVTNIfgJ6pGvYKr1sa63PzIoLrfx0qMKz1QkHGRHK/aU9F+wK3TbxYK+DhHBZXlsyVTmc7034RrKzg9SkskwKtuo9UdWt3tZDVH4VRYWRyWwTfPH2lmCaZ0fHTLG5mAk5yIlBLFJAbfW6clGZfXoyf36XK96LvFmsztVWEMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VTnilfcM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Qg894UjA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=g7ijDT7x; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Y3NbvLg4; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B94431F82D;
	Tue, 16 Jul 2024 09:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721122143; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SnmsKd92bmzpnFMO1WGBlrzh0RIVcYiwCWPOBX7R57M=;
	b=VTnilfcMOiFJ9g01lYPfkxXvHjgL7iPMmS4GyNetVBI1ukpTDT8mve2/OFppYp2ngV/Vus
	raA1aekxrDXM2jmdSgDOfnJYazk/Q8QZxbjmIqGbUOOhaBbuAu91zd5jHE5r/A80BGd+XN
	DImdr0DZmoewUfzUu//MpYNqerTuWUY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721122143;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SnmsKd92bmzpnFMO1WGBlrzh0RIVcYiwCWPOBX7R57M=;
	b=Qg894UjA8EgeaABXsmxxk/xzJ3d+vinzevzLd6VijuBh3CR5hbnvv/hgM2HguAEVwo1USf
	+7EncsJyOzN207DQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=g7ijDT7x;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Y3NbvLg4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1721122142; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SnmsKd92bmzpnFMO1WGBlrzh0RIVcYiwCWPOBX7R57M=;
	b=g7ijDT7x/9WTCwI/DK1nHadH6xesmfiPn3I90nZ5MlalLvUcGCptkzYooEgYfqoXmpcCnn
	/4UMmLaOrzSezwvImijtPT0ff1XrKGBdDC/C1AIQCmYONe/JYU9HCiq5uRrzxF+v//9TGZ
	r2J5L6tXDEH084jhumIqeas8ecrPO6E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1721122142;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SnmsKd92bmzpnFMO1WGBlrzh0RIVcYiwCWPOBX7R57M=;
	b=Y3NbvLg4vY521w3swn4It9ACi6G+bItmA/SC159fW2he/Hr/iG+zE/c3E/jZ4mybynZDDa
	03mLZO3fzz096cBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 838D513795;
	Tue, 16 Jul 2024 09:29:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Z0y/Hl49lmajHAAAD6G6ig
	(envelope-from <nstange@suse.de>); Tue, 16 Jul 2024 09:29:02 +0000
From: Nicolai Stange <nstange@suse.de>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: raschupkin.ri@gmail.com,  live-patching@vger.kernel.org,
  pmladek@suse.com,  mbenes@suse.cz,  jikos@kernel.org,
  jpoimboe@kernel.org
Subject: Re: 
In-Reply-To: <ZpWEifTpQ1vc1naA@redhat.com> (Joe Lawrence's message of "Mon, 15
	Jul 2024 16:20:25 -0400")
References: <20240714195958.692313-1-raschupkin.ri@gmail.com>
	<ZpWEifTpQ1vc1naA@redhat.com>
Date: Tue, 16 Jul 2024 11:28:57 +0200
Message-ID: <877cdlsn1i.fsf@>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Bar: /
X-Rspamd-Queue-Id: B94431F82D
X-Spamd-Result: default: False [-0.31 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	INVALID_MSGID(1.70)[];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	SUBJECT_ENDS_SPACES(0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,suse.com,suse.cz,kernel.org];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim]
X-Spam-Flag: NO
X-Spam-Score: -0.31
X-Rspamd-Action: no action

Hi all,

Joe Lawrence <joe.lawrence@redhat.com> writes:

> On Sun, Jul 14, 2024 at 09:59:32PM +0200, raschupkin.ri@gmail.com wrote:
>>=20
> But first, let me see if I understand the problem correctly.  Let's say
> points A and A' below represent the original kernel code reference
> get/put pairing in task execution flow.  A livepatch adds a new get/put
> pair, B and B' in the middle like so:
>
>   ---  execution flow  --->
>   -- A  B       B'  A'  -->
>
> There are potential issues if the livepatch is (de)activated
> mid-sequence, between the new pairings:
>
>   problem 1:
>   -- A      .   B'  A'  -->                   'B, but no B =3D  extra put!
>             ^ livepatch is activated here
>
>   problem 2:
>   -- A  B   .       A'  -->                   B, but no B' =3D  extra get!
>             ^ livepatch is deactivated here

I can confirm that this scenario happens quite often with real world CVE
fixes and there's currently no way to implement such changes safely from
a livepatch. But I also believe this is an instance of a broader problem
class we attempted to solve with that "enhanced" states API proposed and
discussed at LPC ([1], there's a link to a recording at the bottom). For
reference, see Petr's POC from [2].


> The first thing that comes to mind is that this might be solved using
> the existing shadow variable API.

Same.


> When the livepatch takes the new
> reference (B), it could create a new <struct, NEW_REF> shadow variable
> instance.  The livepatch code to return the reference (B') would then
> check on the shadow variable existence before doing so.  This would
> solve problem 1.
>
> The second problem is a little trickier.  Perhaps the shadow variable
> approach still works as long as a pre-unpatch hook* were to iterate
> through all the <*, NEW_REF> shadow variable instances and returned
> their reference before freeing the shadow variable and declaring the
> livepatch inactive.

I think the problem of consistently maintaining shadowed reference
counts (or anything shadowed for that matter) could be solved with the
help of aforementioned states API enhancements, so I would propose to
revive Petr's IMO more generic patchset as an alternative.

Thoughts?

Thanks,

Nicolai

[1] https://lpc.events/event/17/contributions/1541/
[2] https://lore.kernel.org/r/20231110170428.6664-1-pmladek@suse.com

--=20
SUSE Software Solutions Germany GmbH, Frankenstra=C3=9Fe 146, 90461 N=C3=BC=
rnberg, Germany
GF: Ivo Totev, Andrew McDonald, Werner Knoblich
(HRB 36809, AG N=C3=BCrnberg)

