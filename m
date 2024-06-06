Return-Path: <live-patching+bounces-324-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57FF78FE3C2
	for <lists+live-patching@lfdr.de>; Thu,  6 Jun 2024 12:06:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3DB91C22E34
	for <lists+live-patching@lfdr.de>; Thu,  6 Jun 2024 10:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7D2188CAC;
	Thu,  6 Jun 2024 10:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="JDFJEaf/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JPSAlUCF";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cKj8Uffm";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OMNdqHDd"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D068F18735A;
	Thu,  6 Jun 2024 10:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717668353; cv=none; b=iIRbwczd9XLHo94lpESsU/U2Y/D4+1mekAhdp2j7dSmcqUx/yNWYvOIlToP7VlMDTnt2yq3czbIBY5iVbiVpukr81Zj8FU8rhpb+mDXmaCJYHLMV/wsz9CV0UKaLN1OoqULmW7uQrAlZWwlIvBBBEbAttr7SiY5/Om5jcHfK8xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717668353; c=relaxed/simple;
	bh=/UgyuGsmkOVdtTEni8V4ajsheyVGCdZB24IXLzeCFqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JKphiqrfMXw7BFPshwK4ozu5zq/dcQeFATPz21JtMfZ/y1t77kja+MOAJTjeQlmoj6+Iym+SR+q/IXA1zxBCFesiHG5mXRjr+05zSuAugax6U+efZssfe3jdaNE51MHj5A9rpeE0CDsJnbQMfvYavXr7W8pBmDoKbA7FVG3e6Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=JDFJEaf/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JPSAlUCF; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cKj8Uffm; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OMNdqHDd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8CD751F8BA;
	Thu,  6 Jun 2024 10:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717668348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=inxMAwVDRCNuT5jz/h0b34yd72JuHLcJVK3CGeKxP9Y=;
	b=JDFJEaf/IszgxWpKHZ5D0mEAwWZRLHlMW2WjWiPHta4kiUzmPLx5H+/jUFuMgcq0DBjSYh
	Pp6Haq5M5nbyiFkXJjHV4HVqPPiPLCTzbK7T94CZqI4pQ8JyVcqoPvqK+NfiUrt0Nq0P8E
	E6/fqkGHgracjDkFgSLkLkAHwCZgRvo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717668348;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=inxMAwVDRCNuT5jz/h0b34yd72JuHLcJVK3CGeKxP9Y=;
	b=JPSAlUCFNXU8TLRUk1PGv32/bU+bD3Y8sPXJ7WSgTj/dk9yD0CKk1Q+YeyUZgjjcXGTrIh
	6bLvopHlo+rJZOBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cKj8Uffm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OMNdqHDd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717668347; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=inxMAwVDRCNuT5jz/h0b34yd72JuHLcJVK3CGeKxP9Y=;
	b=cKj8UffmM2xDfX/qJIyejoHY6MdF/ityNV6fb87gS1D5QoLJkrcoAaoBOmSQ7mmjQb3VrR
	bVRJoPJU+AqU5VahZUUya7aQs/Ct+GMfKdb7jLTXI++xRz8a0JMG4gD6/o0nfzF9uwg3Ny
	BzgIz1IgHqo0X61RKSqVP02sbhYZzuk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717668347;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=inxMAwVDRCNuT5jz/h0b34yd72JuHLcJVK3CGeKxP9Y=;
	b=OMNdqHDdbHQLxXhz+YFOe8Im3SvIRZPo2cHnjDNv97yCC0dEJK6KHukkYRRFjdm8dYBhmB
	U29CSNy7UEDwHvDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E2EF13A1E;
	Thu,  6 Jun 2024 10:05:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RG9AHvuJYWbZBQAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Thu, 06 Jun 2024 10:05:47 +0000
Date: Thu, 6 Jun 2024 12:05:42 +0200
From: Lukas Hruska <lhruska@suse.cz>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Lukas Hruska <lhruska@suse.cz>, pmladek@suse.com, mbenes@suse.cz,
	jpoimboe@kernel.org, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	mpdesouza@suse.com, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 2/6] livepatch: Add klp-convert tool
Message-ID: <ZmGJ6zMU-0OG29Uk@localhost.localdomain>
References: <20240516133009.20224-1-lhruska@suse.cz>
 <20240516133009.20224-3-lhruska@suse.cz>
 <ZljceDZ7eqEJtYhQ@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZljceDZ7eqEJtYhQ@redhat.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,godbolt.org:url]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 8CD751F8BA
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.51

Hello Joe,
> > +#define KLP_RELOC_SYMBOL_POS(LP_OBJ_NAME, SYM_OBJ_NAME, SYM_NAME, SYM_POS)	\
> > +	asm("\".klp.sym.rela." #LP_OBJ_NAME "." #SYM_OBJ_NAME "." #SYM_NAME "," #SYM_POS "\"")
>                                                                             ^^^
> I think I found a potential bug, or at least compatiblity problem with
> including a comma "," character in this symbol format and older versions
> of the GNU assembler.  The good news is that other delimiter characters
> like "." or "#" seem to work out fine.

Thank you for spotting this. I was using binutils 2.38, so I did not
even notice this problem. Unfortunately, I was not able to make it work
with "#" as a delimiter; only "." worked. Additionally, any type of
parenthesis apparently has some special purpose even in labels, so they
are also not an option.

> If you want to reproduce, you'll need a version of `as` like binutils
> 2.36.1 and try building the samples/livepatch/livepatch-extern-symbol.ko
> and you should get an error like:
> 
>   Assembler messages:
>   Warning: missing closing '"'
>   Warning: missing closing '"'
>   Error: too many memory references for `movq'
> 
> 
> If you want to retrace my adventure, here are my steps:
> 
>   1) Clone klp-convert-tree repo branch containing this patchset +
>   Petr's review comments + a few helpful things for klp-convert
>   development:
>   
>     $ git clone \
>         --single-branch --branch=klp-convert-minimal-v1-review --depth=9 \
>         https://github.com/joe-lawrence/klp-convert-tree.git
>     [ ... snip ... ]
>     $ cd klp-convert-tree
>   
>   2) Override .cross-dev defaults:
>   
>     $ export BUILD_ARCHES=x86_64
>     $ export COMPILER=gcc-11.1.0
>     $ export URL=https://cdn.kernel.org/pub/tools/crosstool/files/bin/x86_64/
>     $ export OUTDIR_PREFIX=$(pwd)/build
>     $ export COMPILER_INSTALL_PATH=$(pwd)/cross-compiler
>   
>   3) Setup x86_64 default .config (this will download and install the
>   gcc-11.1.0 compiler from cdn.kernel.org):
>   
>     $ ./cross-dev make defconfig
>     
>     x86_64 : make defconfig ...
>     Compiler will be installed in /root/klp-convert-tree/cross-compiler
>     [ ... snip ... ]
>   
>   4) Add kernel livepatching configuration options:
>   
>     $ ./cross-dev klp-config
>     
>     Configuring x86_64 ...
>     [ ... snip ... ]
>     
>     $ grep LIVEPATCH "$OUTDIR_PREFIX"-x86_64/.config
>     CONFIG_HAVE_LIVEPATCH=y
>     CONFIG_LIVEPATCH=y
>     CONFIG_SAMPLE_LIVEPATCH=m
>   
>   5) Run the cross-compiler build until it hits a build error on
>   livepatch-extern-symbol.ko:
>   
>     $ ./cross-dev make -j$(nproc)
>     [ ... snip ... ]
>     make: Target '__all' not remade because of errors.
>     [ x86_64 : make -j48 = FAIL ]
>   
>   6) With pre-requisites already built, retry the external symbol sample
>   and add -save-temps to the KCFLAGS to keep the generated assembly file:
>   
>     $ KCFLAGS="-save-temps=obj" ./cross-dev make samples/livepatch/livepatch-extern-symbol.ko
>     [ ... snip ... ]
>     samples/livepatch/livepatch-extern-symbol.s: Assembler messages:
>     samples/livepatch/livepatch-extern-symbol.s:103: Warning: missing closing '"'
>     samples/livepatch/livepatch-extern-symbol.s:103: Warning: missing closing '"'
>     samples/livepatch/livepatch-extern-symbol.s:103: Error: too many memory references for `movq'
>     [ ... snip ... ]
>   
>   7) Which line is that?
>   
>     $ awk 'NR==103' "$OUTDIR_PREFIX"-x86_64/samples/livepatch/livepatch-extern-symbol.s
>             movq    ".klp.sym.rela.vmlinux.vmlinux.saved_command_line,0"(%rip), %rdx
> 
> 
> You could alternatively poke at it through the compiler explorer service
> and toggle the source and binutils versions:
> 
>   (error)   binutils 2.36.1 : https://godbolt.org/z/cGGs6rfWe
>   (success) binutils 2.38   : https://godbolt.org/z/ffzza3vYd

Thank you for those detailed step-by-step instruction to reproduce it!
It helped me a lot to understand the problem.

Lukas

