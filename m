Return-Path: <live-patching+bounces-281-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE7A8CA80B
	for <lists+live-patching@lfdr.de>; Tue, 21 May 2024 08:34:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6D111C20E2B
	for <lists+live-patching@lfdr.de>; Tue, 21 May 2024 06:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845B1433DF;
	Tue, 21 May 2024 06:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lJq72kFv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4D4uKXIe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UMvuNjdK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4h3o2of1"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564BA41C63;
	Tue, 21 May 2024 06:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716273292; cv=none; b=pStt1UrT4Mg4dMWQQtpYr97Gqw44IpWj28bbT1qrzF8J9gNbAGOzUV+SX/dGBafavdz7w/xK81DBTn9hJQbmjZvzXyRHeoZUwYJVTFClBk+EinGPkopicGUwoksr+2QOxXbVZGQrY/YRz4TXYK4G6oPh1ALViqH69QXnXJMYmug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716273292; c=relaxed/simple;
	bh=4ts5pYQV3oug49Y920NlVmae5l/HmS5VVHrB2NE+Qpk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Y3VX5IrPfF0TPgxmRpnWhK48whZqt8OQ5f0+1heAd5ZGEk5UVoIsmr4yKC18dwxZxCX+pWC0Sn0sh2UiyIY3qxVCBAIEWK1rwSUydwEFqcDYwG5FQGSeHlMOhTzoYFGgVqTDPYweM2iXLk93RcfvQHxtKGdUHOHzViIFcXS5dGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lJq72kFv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4D4uKXIe; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UMvuNjdK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4h3o2of1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2588033A03;
	Tue, 21 May 2024 06:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1716273288; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=goqT7bQnK98dqnw2gijHAX4F/v81FNGH9wk6IRyAp0U=;
	b=lJq72kFvj2eyb2LF3jq6l2Dld1ffnIPvcSvUmiUOEfcKWRTx2P2kUTn4W9ctur9v62k/Fh
	E86a7Jk4ld/YMe8SDZLQ8MW0gjYzDF6dCXhdgQlS/9CPrhouzsJFXjsmmrfwkUdDFmonYK
	Eee59yz3/4/Fm8cxTGyXhjOLr1dkqFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1716273288;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=goqT7bQnK98dqnw2gijHAX4F/v81FNGH9wk6IRyAp0U=;
	b=4D4uKXIeQq3Kt+KMsIjXi2r4ef9o87HfyjzGnMmgbAkDCXPGvmbIQB/6zDY72NR9JZPeBF
	8lsFFctKle8SU8AQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1716273287; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=goqT7bQnK98dqnw2gijHAX4F/v81FNGH9wk6IRyAp0U=;
	b=UMvuNjdKAzObHolRoxvs2lInhD/eKGHGV0EInN6YUADXwODbS4vY+HKkJyoDWKY76yWPXF
	IpYoc+fv/cG0dQyHOpkOzfvdtRdV+SSlfUugWIneqoHhBuXHnc7FFyDS6p4GEX9+5X8VEg
	rj4hYg7LVB6mf16IkshoOrW7n1ZgWYE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1716273287;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=goqT7bQnK98dqnw2gijHAX4F/v81FNGH9wk6IRyAp0U=;
	b=4h3o2of1mcBcefjmaqfMjJEUdYsDDD3yzHCl/S7LFqeYzZrDxoFJ5S8jiK2SaCabxggum0
	nOw7CF8ZP2zRCZAw==
Date: Tue, 21 May 2024 08:34:46 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: zhang warden <zhangwarden@gmail.com>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
    live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
In-Reply-To: <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
Message-ID: <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
References: <20240520005826.17281-1-zhangwarden@gmail.com> <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz> <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="1678380546-445900224-1716272894=:4805"
Content-ID: <alpine.LSU.2.21.2405210833040.4805@pobox.suse.cz>
X-Spam-Flag: NO
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	CTYPE_MIXED_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+];
	FREEMAIL_TO(0.00)[gmail.com];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pobox.suse.cz:helo,suse.cz:email]

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1678380546-445900224-1716272894=:4805
Content-Type: text/plain; CHARSET=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LSU.2.21.2405210833041.4805@pobox.suse.cz>

Hello,

On Mon, 20 May 2024, zhang warden wrote:

> 
> 
> > On May 20, 2024, at 14:46, Miroslav Benes <mbenes@suse.cz> wrote:
> > 
> > Hi,
> > 
> > On Mon, 20 May 2024, Wardenjohn wrote:
> > 
> >> Livepatch module usually used to modify kernel functions.
> >> If the patched function have bug, it may cause serious result
> >> such as kernel crash.
> >> 
> >> This is a kobject attribute of klp_func. Sysfs interface named
> >> "called" is introduced to livepatch which will be set as true
> >> if the patched function is called.
> >> 
> >> /sys/kernel/livepatch/<patch>/<object>/<function,sympos>/called
> >> 
> >> This value "called" is quite necessary for kernel stability
> >> assurance for livepatching module of a running system.
> >> Testing process is important before a livepatch module apply to
> >> a production system. With this interface, testing process can
> >> easily find out which function is successfully called.
> >> Any testing process can make sure they have successfully cover
> >> all the patched function that changed with the help of this interface.
> > 
> > Even easier is to use the existing tracing infrastructure in the kernel 
> > (ftrace for example) to track the new function. You can obtain much more 
> > information with that than the new attribute provides.
> > 
> > Regards,
> > Miroslav
> Hi Miroslav
> 
> First, in most cases, testing process is should be automated, which make 
> using existing tracing infrastructure inconvenient.

could you elaborate, please? We use ftrace exactly for this purpose and 
our testing process is also more or less automated.

> Second, livepatch is 
> already use ftrace for functional replacement, I don¢t think it is a 
> good choice of using kernel tracing tool to trace a patched function.

Why?

> At last, this attribute can be thought of as a state of a livepatch 
> function. It is a state, like the "patched" "transition" state of a 
> klp_patch.  Adding this state will not break the state consistency of 
> livepatch.

Yes, but the information you get is limited compared to what is available 
now. You would obtain the information that a patched function was called 
but ftrace could also give you the context and more.

It would not hurt to add a new attribute per se but I am wondering about 
the reason and its usage. Once we have it, the commit message should be 
improved based on that.

Regards,
Miroslav
--1678380546-445900224-1716272894=:4805--

