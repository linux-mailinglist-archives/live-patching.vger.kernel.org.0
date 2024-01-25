Return-Path: <live-patching+bounces-156-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8023E83BDBE
	for <lists+live-patching@lfdr.de>; Thu, 25 Jan 2024 10:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 200841F318ED
	for <lists+live-patching@lfdr.de>; Thu, 25 Jan 2024 09:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C19111C6A6;
	Thu, 25 Jan 2024 09:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nZwCTEIi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wzs65i74";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nZwCTEIi";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wzs65i74"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDDD1C6AF;
	Thu, 25 Jan 2024 09:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706175884; cv=none; b=Q267VntX1Ic8z1vFZDjwnBjqLq3py+/yZJa4G9jlAit5hD2QzoDze9+p1l+RYpu1/OYljoClTk609KMh6dXVhKGS+RRwUwdeTKyAIGpiM/p9wXDNw2hY8SpjklPtCrImfjWwFzKrDLklRit981lRGZmuxT1dzRpt4oPq1WR3OMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706175884; c=relaxed/simple;
	bh=XmRSbkIpywLmjj0zCQiVg5TA0KM3rSYgxhSTDBmH4dc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VPfSnAadnm9SnPw9tmcjfI7nVrNq8l0EHv1XgWoZhbpILKAla89uqzrZOLaxS1SGdpJt4nJqMUbDXe9DMDZEw8DIgGokFIqD2l6AoIDMvnMACZtnoW6zEMeT0z5Cbbs1A8ft7qjOcasGemYVaplzhqRa7W44jVoYCkZgTWUfZCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nZwCTEIi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wzs65i74; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nZwCTEIi; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wzs65i74; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 351C22235C;
	Thu, 25 Jan 2024 09:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1706175881; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oRo4+cA0mWp/kgVI4VrUT42ptptwgy4meaT1AtSPrzE=;
	b=nZwCTEIiBk62Rc9dAJ6ScZKOC5SShGPu39+CPyTXzmB/RYuaNuZwnwU3SyNGUeQgd4RD5x
	KJIDgwgphHw2jGYLoggab4FWVTGt5+12SOI+AklfsgDtNcUWtgjd+yMgwulHq9TvQ08eoO
	Pue1N0tax/AlljXX0qYesvMvl5/u4DQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1706175881;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oRo4+cA0mWp/kgVI4VrUT42ptptwgy4meaT1AtSPrzE=;
	b=wzs65i743jm/cVjCTl9Iys2SvbIdGryFU62x7mokJEqNCOVurTqHGjj53O1MZa8MVffgcV
	WBBs/nrCh2wCDDAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1706175881; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oRo4+cA0mWp/kgVI4VrUT42ptptwgy4meaT1AtSPrzE=;
	b=nZwCTEIiBk62Rc9dAJ6ScZKOC5SShGPu39+CPyTXzmB/RYuaNuZwnwU3SyNGUeQgd4RD5x
	KJIDgwgphHw2jGYLoggab4FWVTGt5+12SOI+AklfsgDtNcUWtgjd+yMgwulHq9TvQ08eoO
	Pue1N0tax/AlljXX0qYesvMvl5/u4DQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1706175881;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oRo4+cA0mWp/kgVI4VrUT42ptptwgy4meaT1AtSPrzE=;
	b=wzs65i743jm/cVjCTl9Iys2SvbIdGryFU62x7mokJEqNCOVurTqHGjj53O1MZa8MVffgcV
	WBBs/nrCh2wCDDAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2BFD713649;
	Thu, 25 Jan 2024 09:44:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3x60CoktsmVbVwAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Thu, 25 Jan 2024 09:44:41 +0000
Date: Thu, 25 Jan 2024 10:44:40 +0100
From: Lukas Hruska <lhruska@suse.cz>
To: Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v1 3/5] kbuild/modpost: integrate klp-convert
Message-ID: <ZbItbbsYrKdWT_Ma@dhcp182.suse.cz>
References: <20231106162513.17556-1-lhruska@suse.cz>
 <20231106162513.17556-4-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106162513.17556-4-lhruska@suse.cz>
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-0.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 MID_RHS_MATCH_FROMTLD(0.00)[];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[9];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -0.10

There is also a typo in Makefile which causes a modules.livepatch file
to be created in kernel sources even in case of building an external
module.

> diff --git a/Makefile b/Makefile
> index 2fdd8b40b7e0..459b9c9fe0a8 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1185,6 +1185,7 @@ PHONY += prepare0
>  export extmod_prefix = $(if $(KBUILD_EXTMOD),$(KBUILD_EXTMOD)/)
>  export MODORDER := $(extmod_prefix)modules.order
>  export MODULES_NSDEPS := $(extmod_prefix)modules.nsdeps
> +export MODULES_LIVEPATCH := $(extmod-prefix)modules.livepatch

This should be `$(extmod_prefix)`.

Best Regards,
Lukas

