Return-Path: <live-patching+bounces-1270-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E1EA5C11F
	for <lists+live-patching@lfdr.de>; Tue, 11 Mar 2025 13:30:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDAF13B31AC
	for <lists+live-patching@lfdr.de>; Tue, 11 Mar 2025 12:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A7F25CC92;
	Tue, 11 Mar 2025 12:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YfpX9E0G"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B212571A1
	for <live-patching@vger.kernel.org>; Tue, 11 Mar 2025 12:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741695935; cv=none; b=aKlUt4Tn7Zr/H8LMicynAL2G648DB7Gq9pb7MvTDPY3EteMe3wPxVo6j6vw0GjTily+wrrybMfM55v1qmwYShfsKqjYqy2gm64WWtBhIXPIqJMnkcAjm/H0TL4bjvf0ng871mco0gBO5w5ruHkVaFZzbmzYl6am2fLAchmU+610=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741695935; c=relaxed/simple;
	bh=Yq3xrN4lvfTaBga4VB+YNF7SlTGdbi09E1Omdh5chn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kGaSa9+II825ulLjSXaCim5ymXUsRnZXbD+NEdjcJ3ttv7lgULW3I8RS7vHF9jstDFmADWqRIR/4XaTzVOh+9QYDMRmtkbVdm5PPUp9DRpkdoxXSR6ukglvXjKswGVnanfxjlCerKyr2ZQRj56fiTKeTOehF1D+4+jeX3/VlIf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YfpX9E0G; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3912d2c89ecso4671494f8f.2
        for <live-patching@vger.kernel.org>; Tue, 11 Mar 2025 05:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741695931; x=1742300731; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j2U1EYgIyKzq4oZ86DSxNLmCrUC2+yLHgcLc3cZSvVU=;
        b=YfpX9E0G/L81n2KxqJdsTW8sXS5wP/Tzd1zobDO49En0KKXYP+P0vvVpvvuo5L7BMG
         yk1SGsXBai3ZwM6gkgn5BSKfbF0BeAOKyYvokWrk1bkakzh+ssM+aedoVvYXgi0R879U
         VNDoBzxflpmnJ1MnUemx0/wCY1T1bDmK51tDG7zf3qJtlpLHUMxps/FpwTII04mMKNNQ
         l6bEzBb7DZ1R5DBWsf7pbon+O/XijXns411Lke/EWxhHbLA4/TGkIutm6VaDRUc/rRGA
         9vFRJYFVTM1CQNDopSOderjIShU2PeWshOcv8C7Ec+agUcwciLuKZ3wYSHtLgrVhzDTq
         WoUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741695931; x=1742300731;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j2U1EYgIyKzq4oZ86DSxNLmCrUC2+yLHgcLc3cZSvVU=;
        b=dsaELpcwiLoW7IGnC/OVL6GG4gvp1ZrDxyyvGFdwgv8XZZDGeWTUg67GrSmESIhoTd
         NQZnidV0Y7mx0yeR7W8AwhNHd4ZsGJKb3kf5+uVJaCWBninXlud8MjVP6wYHYh1cOXVK
         mK23eTw3Yt0WYB/DtGAb8tUYYzwfrcVISAgCeCuI4dMPmj1WwptaS+pTGj+6GovPUwmr
         0DkeAJ6SmEEVoLac0vhraztxMFcG5OVZaxqTeZgSRXBY3Vnl5Lm0OBZjpgehrElT+FA0
         u6FX/Jzh+22f1OXBhB1a/HWH+ybIS3b2bt3N9lQmzImi8bCXwS5Lpsaj/VuGPHF3Hoxa
         jOjw==
X-Forwarded-Encrypted: i=1; AJvYcCXioInfSVzZKDbctR3ftvMi2TcgyzdaVkMB7AyyhMCQCu0FmWW3c6naIyMPkibpwpQIdHv4RphmQ3vYpAqO@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe7yWlRQ/LjHBFp89FwRo4N8w8lJoIF5KCIRWS7Nt6tVur3/pH
	VoJjpLfz96t+zw1sevVj1sMYhandPqSLxeIGoH8NAOjOd3K1EJ/0ponXWLbzx5A=
X-Gm-Gg: ASbGncsqzmTwzt3aDAtg7YWztYMPxwV/6EH+kqhR1ADweiPexTFdJyA2f8iiaH8CYER
	UxWatuJFuFhIUOZ+7ncGYYmBnoTAuPebPXEh8WsP0zbCcPBZ/JoBKNsENc+8G0qW4T3Ot5al3wU
	3n7FsEOmqlo6gTVydPn4KNI7TC8b9785Kw8aHT9aXMrDxBVr7BDMoN7/6xpWSHMGoh/I9oCylGD
	FwLFbQMr4KWpUs3BI51eNT8ykicLBIIwe9ll5SwcdYjwBxj7jboFmrk+O+X7LfmX/qLe79EMgZd
	sbdKdMoj4+/8NtngF55HrDShWwdGlacxqyMUL0nZaGno9W4fvAFOLa3fqg==
X-Google-Smtp-Source: AGHT+IFcQmJwU8Cto6/d/5e5OV6MBIcnsHI8rHqc/utPjYb4xkOHk774cEqa7CzCd2JrRgZevlhDOg==
X-Received: by 2002:a5d:64e4:0:b0:391:4bcb:828f with SMTP id ffacd0b85a97d-3914bcb84bbmr8055000f8f.14.1741695931250;
        Tue, 11 Mar 2025 05:25:31 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd4353003sm215945895e9.28.2025.03.11.05.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 05:25:30 -0700 (PDT)
Date: Tue, 11 Mar 2025 13:25:29 +0100
From: Petr Mladek <pmladek@suse.com>
To: zhang warden <zhangwarden@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org
Subject: Re: [RFC] Add target module check before livepatch module loading
Message-ID: <Z9ArueBi3cd3OLEo@pathway.suse.cz>
References: <C746373C-96ED-47EE-94F2-00E930BE2E8B@gmail.com>
 <Z8r6AKBU4WPkPlaq@pathway.suse.cz>
 <3524E557-77AD-427C-82BA-6CA06968AC5B@gmail.com>
 <Z88JxGTGMcBEeHVP@pathway.suse.cz>
 <911AD123-9CA6-405A-8D63-6F0806C12F84@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <911AD123-9CA6-405A-8D63-6F0806C12F84@gmail.com>

On Tue 2025-03-11 11:53:59, zhang warden wrote:
> > A single livepatch could modify more objects: vmlinux and several
> > modules. The metadata for each modified object are in "struct
> > klp_object". The related obect is currently identified only by obj->name.
> > And we could add more precision identification by setting
> > also "obj->srcversion" and/or "obj->build_id".
> > 
> 
> Yep, but how can we get the obj->srcversion? If we tring to store it 
> in klp_object, the information should be carried when livepatch is being build.
> Otherwise, we don't know which srcversion is good to patch, isn't it?

I am not sure if I get the question correctly.

Anyway, struct klp_object must be defined in any livepatch, for example, see
/prace/kernel/linux/samples/livepatch/livepatch-sample.c

I guess that you are using kPatch. I am not sure how it initializes
these klp_patch, klp_object, and klp_func structures.
But it has to create struct klp_object for the livepatched module
and initialize at least .name, .func items.

The srcversion of the livepatched module can be read by modinfo,
for example:

# modinfo test_printf
filename:       /lib/modules/6.13.0-default+/kernel/lib/test_printf.ko
license:        GPL
description:    Test cases for printf facility
author:         Rasmus Villemoes <linux@rasmusvillemoes.dk>
test:           Y
srcversion:     AF319FC942A3220645E7E99
depends:        
intree:         Y
name:           test_printf
retpoline:      Y
vermagic:       6.13.0-default+ SMP preempt mod_unload modversions 

You need to teach kPatch to read the srcversion of the livepatched
module and set it in the related struct klp_object.

Best Regards,
Petr

