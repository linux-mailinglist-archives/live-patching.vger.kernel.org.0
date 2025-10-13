Return-Path: <live-patching+bounces-1747-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E3797BD3B7F
	for <lists+live-patching@lfdr.de>; Mon, 13 Oct 2025 16:54:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CA49D4FAC5A
	for <lists+live-patching@lfdr.de>; Mon, 13 Oct 2025 14:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A761F03C9;
	Mon, 13 Oct 2025 14:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Lqdc9jFG"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3201F419B
	for <live-patching@vger.kernel.org>; Mon, 13 Oct 2025 14:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366725; cv=none; b=pabfkhoa1lBpSNxao5Ve6VqoYUdrnBz4OKing5wVgurZE45+PezpU17GtTxTR/SvoAjBr7zGP5Dd/fB+zZIcpefhhodk5GYbzVQ6cVNM1FVwyIJMhoTrVvK1HU1Rt+arg7QfWsvNYmkJOiLAdYW4Xaoiz3YDjoUEU7IL8WmP+SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366725; c=relaxed/simple;
	bh=BSViH4a+gQGqOv4otv6apWwBop7ShHYzBocW8+38l+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZs7nzaTZu1limj8Gcyp60lz+8KtsZc2RHr2FX3oXCyYz5jAokB9Coqf5yk3GeEXidEL0TT/SA0HJn/lUfFcnFIlvcGdM5d2mHt2lucQte8D51/h2rdH5hGg1JuSO8fZulUe6XucP7ywEjFXJOOdKitacVkWaZXbgnbF/2K8H6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Lqdc9jFG; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e2e363118so36969825e9.0
        for <live-patching@vger.kernel.org>; Mon, 13 Oct 2025 07:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760366721; x=1760971521; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/GVyo1/V7g7/gMvAZxkyzbI/R8KG1zHfCybbIMNlK3Y=;
        b=Lqdc9jFGuGriGLVDUdoUJ2QsustX25OnN/OnKSdhRHO4hpUb+N2zAqX5PXLsDa3Us8
         duRfIDr04k/8f7yQj+SbaZY1MAedOnN9QOWlKfHhsiij8ZI7MtEVDI3c0RkXGO3N9b63
         pZKu2w+XjApfEX6i+a8J9hHu6A/Ppvmz67T8VMQ9r+nBczRDxSkPcGhGj+U7swLVB8ih
         BzG2GNzlyCUjOzDgh3qg/0VWt5W6NeJlc270DODBUA33JbV/WN/kQCH8RlFh/DAnOHPW
         zhAPOhQNrEqbD/X2N3UhJ81RDfZMXrR8nXeS8BeaCUKPi6rGX+VNa1YTmsfklkNvWSya
         4Yow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760366721; x=1760971521;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/GVyo1/V7g7/gMvAZxkyzbI/R8KG1zHfCybbIMNlK3Y=;
        b=RsHTFkA5Sv2wzMyiYbD7mU1TvIWPfYq+rPEr4Azn/zdl4YtEHNpwUcd9clR8VUqUkC
         guxo1HQAZccjjQ776NM/ZkbOStMbYrl6vxyFEq9Lw5/1lUJEqcErSUyS054JqIt01Zeq
         5kh7hqT4GOBUsDTKtdtL5mmYgkJvbz0p+W0fKnV5c7jxfXStWasRT9B9usYqfnE9eldg
         RB9RkEpv3XAXOLGesbTPmA6nQjjzhztScHnoG8ssknKBBYwFoBVb3sOmwyl1kO37JWuC
         bR8DeAU4gWCgSDcNtXAUyZgM45zCkb6J5B3fh/HQzf05++vEsUArYqPZajI9vG+sEZCF
         v9lQ==
X-Gm-Message-State: AOJu0Yx3atKrBLVWk24TwrpTMgZxN+abMAevYhfBDNV7R4Sxvwe8nBUx
	RMy3werfoX0AR6Y8TET/czVlHZLP6luNLvKBInefUS4wLAgQmZhqvDqamrqoxQn2QVJD5mPC++h
	kI19+
X-Gm-Gg: ASbGncugBJmAw5yL7wEIAClZuNR0k9voWCprYfWI467UpD9sWu3uq2FhMinqSyvzac1
	2/HS0U7fb1oKt1J0NvjR5AtuCXvuN9swtZ0hBZffc+LbSYX8UuLL+lkcWtyoUh3ry0p619QxBLo
	52mg4asRXF8B42eHtIiwJGpOc+pzXhMzaP/ONpJHa1oPfjm62XPfh+OzWhxmD32t2GDouXAKz28
	5LKIKLgNpp2WqwDVqTGthcIHDxCD/bGX9NfUwnwbMY3Iz3woaJZyZMqTBoAEfoHWD+mlVSMIcyR
	Ko5XP6b/6KPgQfcvopJ98lNnXYLvc8kmSl5D70hTwAyNw5ZtnLo0uKphxMp2oVY2fBS419V1sBy
	pLG35zH4jbssjDkZH8ExxRjas4h+MT22tKM7Gs51lLh+qZEyJPxR5X8Y=
X-Google-Smtp-Source: AGHT+IFMLV81TAMyQPpQjoqwvyKKpRiFTDWK90NJoSNjGruYawzfxssM40yXojn0XfT0uNG986RG7Q==
X-Received: by 2002:a05:600c:4753:b0:46e:1a5e:211 with SMTP id 5b1f17b1804b1-46fa9aef2d4mr150218415e9.21.1760366721084;
        Mon, 13 Oct 2025 07:45:21 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb483bbb4sm185994695e9.5.2025.10.13.07.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 07:45:20 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:45:18 +0200
From: Petr Mladek <pmladek@suse.com>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH] livepatch: Match old_sympos 0 and 1 in klp_find_func()
Message-ID: <aO0QfgEsIk0wh0Zw@pathway.suse.cz>
References: <20251010230223.4013896-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010230223.4013896-1-song@kernel.org>

On Fri 2025-10-10 16:02:23, Song Liu wrote:
> When there is only one function of the same name, old_sympos of 0 and 1
> are logically identical. Match them in klp_find_func().
> 
> Signed-off-by: Song Liu <song@kernel.org>
> 
> ---

I would prefer to add the details into the commit message.
It would make it clear that it was a real life problem.
Also it explains the effects.

It would just need to convert the text into the imperative
style, like:

   There are two versions of kpatch-build, ...

Even better would be to mention which version introduced the change.
But it is not strictly necessary.

> This is to avoid a corner case I hit in testing.
> 
> I had two versions of kpatch-build, one assigns old_sympos == 0 for
> unique local functions, the other assigns old_sympos == 1 for unique
> local functions. Both versions work fine by themselves.
> 
> However, when we do patch upgrade (with the replace flag) with a

Imperative language:

   During the patch upgrade (with the replace ...

> patch built with one version of kpatch-build to replace the same fix
> bult with the other version of kpatch-build, we hit errors like:
> 
> [   14.218706] sysfs: cannot create duplicate filename 'xxx/somefunc,1'
> ...
> [   14.219466] Call Trace:
> [   14.219468]  <TASK>
> [   14.219469]  dump_stack_lvl+0x47/0x60
> [   14.219474]  sysfs_warn_dup.cold+0x17/0x27
> [   14.219476]  sysfs_create_dir_ns+0x95/0xb0
> [   14.219479]  kobject_add_internal+0x9e/0x260
> [   14.219483]  kobject_add+0x68/0x80
> [   14.219485]  ? kstrdup+0x3c/0xa0
> [   14.219486]  klp_enable_patch+0x320/0x830
> [   14.219488]  patch_init+0x443/0x1000 [ccc_0_6]
> [   14.219491]  ? 0xffffffffa05eb000
> [   14.219492]  do_one_initcall+0x2e/0x190
> [   14.219494]  do_init_module+0x67/0x270
> [   14.219496]  init_module_from_file+0x75/0xa0
> [   14.219499]  idempotent_init_module+0x15a/0x240
> [   14.219501]  __x64_sys_finit_module+0x61/0xc0
> [   14.219503]  do_syscall_64+0x5b/0x160
> [   14.219505]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [   14.219507] RIP: 0033:0x7f545a4bd96d
> ...
> [   14.219516] kobject: kobject_add_internal failed for somefunc,1 with
>     -EEXIST, don't try to register things with the same name ...
> 
> This happens because klp_find_func() thinks somefunc with old_sympos==0
> is not the same as somefunc with old_sympos==1, and klp_add_object_nops
> adds another xxx/func,1 to the list of functions to patch.
> 
> Yes, this is a really rare case, and the toolchain (kpatch-build) should
> be consistent with old_sympos. But I think we may want to fix the
> behavior in kernel just in case.

The last paragraph should not be in the comment.

Otherwise, I think that the change is worth it. As you say,
it is a rare case. But it clearly might happen. And the change
makes the livepatching code more robust.

Best Regards,
Petr

