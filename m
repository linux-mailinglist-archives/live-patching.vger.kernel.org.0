Return-Path: <live-patching+bounces-2268-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cH5yOsmBymkI9gUAu9opvQ
	(envelope-from <live-patching+bounces-2268-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 30 Mar 2026 15:59:37 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D3B235C767
	for <lists+live-patching@lfdr.de>; Mon, 30 Mar 2026 15:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 903DE3044803
	for <lists+live-patching@lfdr.de>; Mon, 30 Mar 2026 13:49:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3876D3BAD8D;
	Mon, 30 Mar 2026 13:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TbpTuWxO"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E123C9EDF
	for <live-patching@vger.kernel.org>; Mon, 30 Mar 2026 13:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774878543; cv=none; b=cNStgvvQDg3jEvuvgcgkEM5G+QfXh3IBLZa5mXN6SXEf3EJDF5krXXvbIcLJUHILEdmHmn2MCfIwy+dFRwz/U9DrutQdczWJ1JhA9TR9o5vUgJInn5SOnLjq8CProRISWDcXcFmS0agzXap8R60idMbS/rRXBJEbcF+fcUA1F0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774878543; c=relaxed/simple;
	bh=XkO1wPeal3Kc8w275PiOatPBzgWgLU7yfkQaxOpKYzc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkTo9dJzUI5Yr+P7jH9Ni3lFUfDjDmsT9N6aijeW8TrY+4ZL9vlE79kS9sX3A3vbSKzfAY7YEWQS6VcqqoNltL5OxjWE++pfZ98QOEaaUOY8+ErxWQsVpS3gp0yecYPnbt9/nvAyx8BzOcldHq2f1odpYe02R6SS37bvvb2gj1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TbpTuWxO; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso39030275e9.1
        for <live-patching@vger.kernel.org>; Mon, 30 Mar 2026 06:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774878540; x=1775483340; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=njb2j7pkbXogpjPTY38oH4qSs8U+jP8c+JG2E4esAKs=;
        b=TbpTuWxOaP7Qwz4V808ahKSugVmVHWlAewXrKDlL9/zCSgoT1pwiw8jC2n7KQNEjkX
         ps6dedA0Yh2KPCDci4Germ0jpWVGqhTsh5+Ut78tADMczfThh+LYUH6anHaX5ly0JAWK
         E7ESwQmpQMav9kFpCXsAhSOOvBJ+eQweYwog0NKkpG6Dtx4/nHg080OUedMg+/jUkTMj
         REhl3yJVgta6UmP8hCjYSosKrRwZy35i2UFFQ7UrroSSwqeJ9cz1w2XqYnhxqiSfone5
         dRNqtpSyn9bGrI3P6jV6gjCCY11ZzhFSA9QRIqtjb0rs/xylnyhsN7IXWPxS+UmUFIsU
         aKlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774878540; x=1775483340;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=njb2j7pkbXogpjPTY38oH4qSs8U+jP8c+JG2E4esAKs=;
        b=FaFFocHzjLPD7ny3m5w3mNYTUNTPJKUNX5TXcaxinUneiabAI+bVhj/85/um31PnYM
         1MX6i9hKcfn99VEihc+v9B3SUzmiAjLutHMjerXOPLwg0qVDFbBwkz7B4FJZwBjElE+g
         22ak/7A4CoRJDUYsBYU6HrUOOrq6SOPp6WmAYaVQrXxQRRe6/fCO4P7Edwy+gCZVSQKT
         EOfepIRi7sdWCnYG8zQI98aWB7P0tLU6kAj7g1JrR0MeWiSWBQyGDHS2gjZBozp9YThI
         QMsK6LhmS3GvefUgRYBJ0O4kNybk/gpGeHphNkBX86yoMhxK4DhaNLTImRg0d8XVv58H
         37Hw==
X-Forwarded-Encrypted: i=1; AJvYcCXg0gZ0D1F2thi0Qevtak6oTRvuffVZKsoJz7SF0ek0Xk3VSh7k/yr6FkMB5kaZMvrL/CRRAWdnISnlBIAl@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb//tr6qjGt1686ixXeBEwldrdNM+WlygOhzJPk0ztdQtB/qBn
	FCCko9zal0hh8nsBUxCCIDQ3wCT1qlx+V0CPXpC3ezqOlHDR0rY4w42Ev6Mvg7XiPTGs7aRCmXD
	vmDKjtF0=
X-Gm-Gg: ATEYQzxljFECVggmOar7q4T2Pwto1dUvqn+msYqg55bBMU4inWZUcT8vA7Gg+LPw1kZ
	Nb16CgPbCPYUxZxm+SAtAOaMgNMdgAc+xE6dwH5mf8GGc51GUJzCQGEBRVeyzwuu0yuPrS/Ny0r
	4b5qdXQi2RMI3JvKD9YMLUs85z/H422MIWrcVKu44VHAKkDCgDQJmQGD6Q/WKRQPDIrSupEnV1e
	61Ze++wDPe4uob4/6ZbPXPiRp1XrcaGb923+tGisZ4rUlQp6o+vJvv48Z+ILs59YHaaYx37q4gm
	vYFPMWmtcLTv37QZdtnwIFO2sfsXskEoh+vwYtrsyN9Gh6qGJStXvjrf07PfQwbF+VdlS6m2HXT
	9uHpRA7ZffYBbmLuBa5JPm21lnV12wCPYDBDy68vRXbbSbUDiwlHYckevgeMgAVxYdkJyM6H7Ir
	HXA47g4MjlbbnmYDv1jBR7/9CQQw==
X-Received: by 2002:a05:600c:4744:b0:485:2a4b:7bc3 with SMTP id 5b1f17b1804b1-48727d5d6femr207566795e9.4.1774878540187;
        Mon, 30 Mar 2026 06:49:00 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48730628efasm297363515e9.5.2026.03.30.06.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 06:48:59 -0700 (PDT)
Date: Mon, 30 Mar 2026 15:48:57 +0200
From: Petr Mladek <pmladek@suse.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Pablo Hugen <phugen@redhat.com>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	shuah@kernel.org
Subject: speaker-test-module: Re: [PATCH] selftests/livepatch: add test for
 module function patching
Message-ID: <acp_Sa9iyGLdSN04@pathway.suse.cz>
References: <20260320201135.1203992-1-phugen@redhat.com>
 <acVD_NPu4JVRoaVK@pathway.suse.cz>
 <acWZ3r2CoSDy_NLf@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acWZ3r2CoSDy_NLf@redhat.com>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2268-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pathway.suse.cz:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:dkim]
X-Rspamd-Queue-Id: 8D3B235C767
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu 2026-03-26 16:41:02, Joe Lawrence wrote:
> On Thu, Mar 26, 2026 at 03:34:36PM +0100, Petr Mladek wrote:
> > On Fri 2026-03-20 17:11:17, Pablo Hugen wrote:
> > > From: Pablo Alessandro Santos Hugen <phugen@redhat.com>
> > In my RFC, I created a helper module which implemented a person
> > (speaker) which would come on the stage and welcome the audience.
> > I am not sure if it was a good idea. But it became a bit confusing
> > when everything (module name, sysfs interface, function name, message)
> > included the same strings like (livepatch, callback, shadow_var).
> > 
> > Anyway, my tests produced messages like these:
> > 
> > +% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
> > +$MOD_TARGET: speaker_welcome: Hello, World!
> > 
> > , see https://lore.kernel.org/all/20250115082431.5550-9-pmladek@suse.com/
> > 
> > 
> > There were even tests which blocked the transition. They tested shadow
> > variables which added an applause to the message. They did something like:
> > 
> > <paste>
> > All four callbacks are used as follows:
> > 
> >   + pre_patch() allocates a shadow variable with a string and fills
> > 		it with "[]".
> >   + post_patch() fills the string with "[APPLAUSE]".
> >   + pre_unpatch() reverts the string back to "[]".
> >   + post_unpatch() releases the shadow variable.
> > 
> > The welcome message printed by the livepatched function allows us to
> > distinguish between the transition and the completed transition.
> > Specifically, the speaker's welcome message appears as:
> > 
> >   + Not patched system:		 "Hello, World!"
> >   + Transition (unpatched task): "[] Hello, World!"
> >   + Transition (patched task):	 "[] Ladies and gentlemen, ..."
> >   + Patched system:		 "[APPLAUSE] Ladies and gentlemen, ..."
> > </paste>
> > 
> > , see https://lore.kernel.org/all/20250115082431.5550-11-pmladek@suse.com/
> > 
> > Sigh, I have done many changes in the tests for v1. But they still
> > need some love (and rebasing) for sending.
> > 
> 
> If these can be pulled out independently from the v1 patch, perhaps
> Pablo would want to hack on that in a follow up series?

Unfortunately, the selftest changes can't be pulled out easily.
The new test module and related livepatches are implemented using
the reworked livepatch API. :-/

I hope that I'll find time to work on it rather sooner than later.

Best Regards,
Petr

