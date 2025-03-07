Return-Path: <live-patching+bounces-1261-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D169AA5696C
	for <lists+live-patching@lfdr.de>; Fri,  7 Mar 2025 14:52:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 344673B6518
	for <lists+live-patching@lfdr.de>; Fri,  7 Mar 2025 13:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 505FE192589;
	Fri,  7 Mar 2025 13:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PDO3aNWO"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E33621ABA2
	for <live-patching@vger.kernel.org>; Fri,  7 Mar 2025 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741355526; cv=none; b=umJNr9U6rZGCxelB5ZdjfLumFsVWi9FGuVHHzichMmFXcLFHqEP4FiY79Vwl8SfyDZ2MaA2uFWSi1lPpP6ifZIW5vyTmcyDbzNmd25P5dVLFwhAaB+jMMg1FY3T4YAp1Pxl9j4DcpBGd1k17OclhvHDWxH3iXpLHMnRM1KgTs2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741355526; c=relaxed/simple;
	bh=u90bO1QNxSV+kJQgshtAnyUaqGjwFX8hv3AKaLB7p8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bhkil5fbYgbbQ71OI8Nd+l9iFCKORiLt5aezOJYJWWXpLN6JJEbn47qnKwIai24G0TpMNzzd6ddYF3LAoax7uapeYEhFqFFn40bBxovXUDetrNbMsOkf+5ezVr7AL9hQarG/ZBcKGmaBfuiBDnvHNs+8ExkSfoxWkJ+aav1Hhr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PDO3aNWO; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-390f5f48eafso1025667f8f.0
        for <live-patching@vger.kernel.org>; Fri, 07 Mar 2025 05:52:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741355522; x=1741960322; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yKo30fUjdXAj19BYl/T0Tos6Z3d9FGJ7B92Pi4Byxp0=;
        b=PDO3aNWOTxojKxhoJ3D5WpKAyCw9Uh+W5fpF1XzgxzIURbgqmaDhJOQGU6/D8fL+AQ
         1C99+WqZFV7QJCQ6VnfjkavNY3L2WnHcgzlVBvsqLKXhUJmzlzP/m/b6FqGGZzSLiTev
         5gUXG7arotNt/ASCnPAPDGkQ8XtomY/tzav5bttTdJQFSKR7b2zZ0NNMMFnM+3JB+uWS
         Y2y66bGuVTYAMsqVkEPGk3+1APGlVz2ZwaGWKw7NofwEFE13VmyIxtHMLPIk/yLnL5h6
         vIDnG7IDx1qjf4jXJxcOJz1hUx6LquU63q8bp/04Me2AQPCW20RKC1kzST6utmOROBCa
         H8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741355522; x=1741960322;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yKo30fUjdXAj19BYl/T0Tos6Z3d9FGJ7B92Pi4Byxp0=;
        b=R+hP/uKbFcdYuBc0bJOI5W9bVFgzvJkq1TFqyThgtNHqqfcoKAF4Wg0pyaOnpeAUYf
         Pn7XpG+TngxuxQVcBwEDhgGdbYR752EBm29Y2YrVhRF9I4yoPAqHF9hHG/TXtWGxOSAo
         JIzxQEhG2IhFX4Pko02cGkgHtjmG49ttc007WDGJcxgcxKg3kQln0zQkfFMrZw91eBa3
         Lsbr6bRxiIVRsrD/p0gQF+gHYOOoRVd/BNkdeK8PF72aXVZmuH1NLLWNtPlXJ8wf3FfY
         yhQiV5YRXfEa310naBBoRBPzWdEGTFkEAx3Z+FNe6HJw08sPxrgdgolfQydhmlgekOKF
         nLfw==
X-Forwarded-Encrypted: i=1; AJvYcCXjjoNKY+7fZFMksc7L/E8UJwZN3bA+SjnURbtzgEfQHwr4o8cQb7guztcR0FJBruY22ujNYcI324Xe/LKk@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/yovbG6eyiIEs6tsAe2B6HdnLTJaKDFUg9td6Y3WKz2TaKYud
	87GRt81TBxAsn9njoHiAKQLXX0NgbmSS01+Q2QlKyWiAyVhK4bHH22Jo+nPtLWQ=
X-Gm-Gg: ASbGnctY/sXdqhCZ4QXgUp9/W8aY6Pjmr767ynJGLU7lCKhw4uiyJlkYf0GHR0VxDm5
	KnEo8+XvE9Rma64QNFbrP8rPa8WfhXHi9xudasQQ7eQsZuXaOxC8kGEOYZoADj/b9xt6leEOtWM
	fGMo4bR6BWrzRztWP1HtEgPyvF1apMsS29t0rdGZUAw3TL4STLLbENisJ8lwt2XKnPaJW6HsZBu
	rSGtwRiEMbxzJAb9ibJMU+vjbqfCf5yHAJCYHHHHyvYhY0HaBG5ks/CSbSfigG6Ydgsl/Zc2vY9
	5x+052zpAE4o+czrvD/7S9axNxDAoBvUZAJxKzzkJ/nV81Q=
X-Google-Smtp-Source: AGHT+IEyB6eskQ0X7EmzM0N3FRe4WXCWEVuXodFZoAGjDBcJAMaPYHE37Isn1bGP6yuEmUIfNEXHww==
X-Received: by 2002:a05:6000:18ab:b0:391:122c:8aa with SMTP id ffacd0b85a97d-39132d96079mr2199234f8f.30.1741355522215;
        Fri, 07 Mar 2025 05:52:02 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c0e2b6asm5506127f8f.66.2025.03.07.05.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 05:52:01 -0800 (PST)
Date: Fri, 7 Mar 2025 14:52:00 +0100
From: Petr Mladek <pmladek@suse.com>
To: zhang warden <zhangwarden@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org
Subject: Re: [RFC] Add target module check before livepatch module loading
Message-ID: <Z8r6AKBU4WPkPlaq@pathway.suse.cz>
References: <C746373C-96ED-47EE-94F2-00E930BE2E8B@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C746373C-96ED-47EE-94F2-00E930BE2E8B@gmail.com>

On Fri 2025-03-07 11:12:18, zhang warden wrote:
> I had faced a scenario like this:
> 
> There is a fuse.ko which is built as module of kernel source.
> However, our team maintain the fuse as oot module.
> 
> There is a bug of (name it as B1) the original fuse.ko. 
> And our team fix B1 of fuse.ko as release it as oot module fuse_o1.ko.
> Our system loaded fuse_o1.ko. Now, another team made a livepatch module base on fuse.ko to fix B2 bug.
> They load this livepatch_fuse.ko to the system, it fixed B2 bug, however, the livepatch_fuse.ko revert the fix of fuse_o1.ko.
> 
> It expose the B1 bug which is already fix in fuse_o1.ko
> The exposed B1 bug make fault to our cluster, which is a bad thing :(
> 
> This  scenario shows the vulnerable of live-patching when handling 
> out-of-tree module.
> 
> I have a original solution to handle this:
>     • In kpatch-build, we would record the patched object, take the object of ko as a list of parameters.
>     • Pass this ko list as parameter to create-klp-moudle.c
>     • For each patched ko object, we should read its srcversion from the original module. If we use --oot-module, we would read the srcversion from the oot moudle version.
>     • Store the target srcversion to a section named '.klp.target_srcversions'
>     • When the kpatch module loading, we shoud check if section '.klp.target_srcversion' existed. If existed, we should check srcversion of the patch target in the system match our recorded srcversion or not. If thet are not match, refuse to load it. This can make sure the livepatch module would not load the wrong target.

The work with the elf sections is tricky. I would prefer to add
.srcversion into struct klp_object, something like:

 struct klp_object {
 	/* external */
 	const char *name;
+	const char *srcversion;
 	struct klp_func *funcs;
 	struct klp_callbacks callbacks;
 	[...]
 }

It would be optional. I made just a quick look. It might be enough
to check it in klp_find_object_module() and do not set obj->mod
when obj->srcversion != NULL and does not match mod->srcversion.

Wait! We need to check it also in klp_write_section_relocs().
Otherwise, klp_apply_section_relocs() might apply the relocations
for non-compatible module.

Another question is whether the same livepatch could support more
srcversions of the same module. It might be safe when the livepatched
functions are compatible. But it would be error prone.

If we wanted to allow support for incompatible modules with the same
name, we would need to encode the srcversion also into the name
of the special .klp_rela sections so that we could have separate
relocations for each variant.


Alternative: I think about using "mod->build_id" instead of "srcversion".
	It would be even more strict because it would make dependency
	on a particular build.

	An advantage is that it is defined also for vmlinux,
	see vmlinux_build_id. So that we could easily use
	the same approach also for vmlinux.

	I do not have strong opinion on this though.


> This function can avoid livepatch from patching the wrong version of the function.
> 
> The original discussion can be seem on [1]. (Discussion with Joe Lawrence)
> 
> After the discussion, we think that the actual enforcement of this seems like a job for kernel/livepatch/core.c.
> Or it should be the process of sys call `init_module` when loading a module.
>
> I am here waiting for Request For Comment. Before I do codes.

I am open to accept such a feature. It might improve reliability of
the livepatching.

Let's see how the code looks like and how complicated would be to
create such livepatches from sources or using kPatch.

Best Regards,
Petr

