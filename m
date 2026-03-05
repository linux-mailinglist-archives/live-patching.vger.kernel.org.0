Return-Path: <live-patching+bounces-2124-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CK6QHWqOqWni/gAAu9opvQ
	(envelope-from <live-patching+bounces-2124-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 15:08:42 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7990321307D
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 15:08:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 22FDD300E1A9
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 14:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 562C33A5E6D;
	Thu,  5 Mar 2026 14:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OTp3lsGm"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A109A3822AE
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 14:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719715; cv=none; b=UH1ZijgJi4mQ8wNEaqsc/f7XvSPlzFimm3xpGQulNOXIXul0s90Iw2D0OhPD4TsBLzAXi7WsJASSoCRrEYpEWIEQ4JdIjhTB706dJG6vuv80UxajKZnjh/ny9QbUzLDKf/7XpGxHz1bvEoIZRuR9zI12xhnGIkA18H0agzlDv/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719715; c=relaxed/simple;
	bh=O/XjA5uL9EycEGGrj+7zeoihoFADLWUITKLld038LMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obalMyrwWz81DZpDZktgM6RotGD1P/WEn42Pc+WQmhsYg7+52lRFcyvLvUJDMHucw76u0oPGtb0NN0M6hMEXCfDv4g5SVGjwSZjMmFxX3MsZnBE6V4UQCFVC6bQ2y1/izHQq2xpkKWr/s6R2sUmR2IHMc38cMCDP0K7Z5j1u5aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OTp3lsGm; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48069a48629so84937435e9.0
        for <live-patching@vger.kernel.org>; Thu, 05 Mar 2026 06:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772719712; x=1773324512; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rx+DcRV3wyPg0GREsPecQuMIsNLM5EqDJQJIQhPAZMI=;
        b=OTp3lsGmMYJwZxTwdB7lEW691NapsI3DrrRPW0iEz8QC+vn3JHoeqTqwMOfCxzKvKi
         jZVVIZa2WNRWrCid68bdm8x2twofaboi9DgGC8QKw0iuMg066eCDhccrHCqAvWW8DIrj
         0JdeJhcf3c0GXSLTdwr9Gi2ou+lraD8ahCbM/BO5r/686SxbdCOhWjJhGschlRIOewCP
         7ZG7kqgu/MIYcBHYSOU/be3QW3G1TJF4f7Bsrpf1DelsSxFEwaVkKU/XNLyrrmy58vn4
         XK77a1/kGgkasTdzUz9rmfb4W6pj9CnQFIneRap4i6WSu0k07zOPn+BfuvbijiUQrFeG
         2hMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772719712; x=1773324512;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rx+DcRV3wyPg0GREsPecQuMIsNLM5EqDJQJIQhPAZMI=;
        b=tNHrVSqAtiT9rQGljDvuap4XKBTDv7pdHA4J0qK66Wat6M+i/GH2VvPBW1zvf0sMHG
         rl8QOkI+HV7j1eci5p/iA428GOVgUwulu6XStTjQ+E4i9grJ13+ZOtBCEW8HyXSL/PW5
         M+NKIeEn1C37lCyjS6pQJtKtkQDdxTl0MnkQgF3hP9ffOhmacs3hGHyFrWYQ+dtfp1Uu
         kgXH4FV9nK6DMe/EItaMJMCJHYqpV/20kpbnjIKC70AY/PkCparmw2KjTjNW6GHwcV/g
         4CBg2nV4Cv+eTwAVQOvZRQCGonOihDK87WbZSKj6CHykH/rzjYPhr9psFv8XtmOQUiUx
         yIeg==
X-Forwarded-Encrypted: i=1; AJvYcCU8K0+dgYSNx75Z1N7v8bamoZYk/gXoBhZq8SJ31ekEmsVueK+uRkG+NcSgc3XqWhDnhGBTqTdetT4djpWb@vger.kernel.org
X-Gm-Message-State: AOJu0YwmtLpXnfFp1wMAT7EpMLjvJohZacCslLoikaiQq9gm+YeMD9ds
	1+DCX2wQNZfLSkODK5CuFbqj1p7tTm3dGe3pGmbDcPk8OIDzfNZiX33niFUMMhssHFXZA8J6Orl
	jxLoI
X-Gm-Gg: ATEYQzyUPOJVJ/95XWBsw8lnJ3qfvJplVBcT1yvDkx94K4YzP3erTdjlsXRLe1w+YMY
	0529jssJmpAZvC8XSrquiIduzt2WueI2KoedEaIEsjR2xFno3ratL28w7FL03WdreQJWVACEDS0
	AW6/rXR62TLfg5adTC3ogKbfshgv078POE8E92XXd0NcumySr+SDTuF1328bk9d5+gvL+5R9P5q
	3AiZaU+g8Hl7KahPHtpKdf1KeyAmtb/IniW6y7qeTtB/0k0U4kSsY5szK/O+hmhafRDX61NHGzG
	bcwfr8rHhfbws4XlSDheUDjDgB9oxysQy1KRiLccuHDY19JQAcu82rzbHmiX3PjWXSWIaY5QGe9
	LJZfZ825emkYreFizMXJFz+Jv23KUpIhFPN3Qi55O060BtJuWzC4U7rn3ZvdJCFidBa7FtZduBS
	dNMZm4kfPnm3BOtnP4jxOeBpTNtQ==
X-Received: by 2002:a05:600c:1381:b0:483:badb:618a with SMTP id 5b1f17b1804b1-48519897029mr98620545e9.27.1772719711918;
        Thu, 05 Mar 2026 06:08:31 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4851aceb94dsm59314005e9.4.2026.03.05.06.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 06:08:31 -0800 (PST)
Date: Thu, 5 Mar 2026 15:08:29 +0100
From: Petr Mladek <pmladek@suse.com>
To: Song Liu <song@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>,
	live-patching@vger.kernel.org, jpoimboe@kernel.org,
	jikos@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
Message-ID: <aamOXVxBXF8ivyVf@pathway.suse.cz>
References: <20260226005436.379303-1-song@kernel.org>
 <20260226005436.379303-9-song@kernel.org>
 <alpine.LSU.2.21.2602271052240.374@pobox.suse.cz>
 <CAPhsuW69EZTcMGyXSKv2fEjh7mhtYaSxriZrSgX0nTPCEYKS7A@mail.gmail.com>
 <alpine.LSU.2.21.2603020930540.21479@pobox.suse.cz>
 <aaiI7zv2JVgXZkPm@redhat.com>
 <CAPhsuW6Nx6meWVCkTJXmp5BzTX_2s2dt1j+C-=AtMzQ8ZV396A@mail.gmail.com>
 <aajexDFNdFz_Lsrp@redhat.com>
 <CAPhsuW51ihr9mDv6Ov+vJAn_7feqTra2XFXUFm-cb4teE_4s8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW51ihr9mDv6Ov+vJAn_7feqTra2XFXUFm-cb4teE_4s8w@mail.gmail.com>
X-Rspamd-Queue-Id: 7990321307D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2124-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,suse.com:dkim,pathway.suse.cz:mid]
X-Rspamd-Action: no action

On Wed 2026-03-04 21:03:41, Song Liu wrote:
> On Wed, Mar 4, 2026 at 5:39 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
> > > > (Tangent: kpatch-build implemented a unit test scheme that cached object
> > > > files for even greater speed and fixed testing.  I haven't thought about
> > > > how a similar idea might work for klp-build.)
> > >
> > > I think it is a good idea to have similar .o file tests for klp-diff
> > > in klp-build.
> > >
> >
> > kpatch-build uses a git submodule (a joy to work with /s), but maybe
> > upstream tree can fetch the binary objects from some external
> > (github/etc.) source?  I wonder if there is any kselftest precident for
> > this, we'll need to investigate that.
> 
> Ah, right. I forgot that carrying .o files in the upstream kernel is a bit
> weird. That may indeed be a blocker.

I am afraind that caching .o files in the upstream git tree can't work
in priniple. The upstream tree is generic. But .o files are comparable
only when using the same toolchain, ...

Or do I miss anything, please?

Best Regards,
Petr

