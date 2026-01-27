Return-Path: <live-patching+bounces-1925-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6LSXDpwIeGkRngEAu9opvQ
	(envelope-from <live-patching+bounces-1925-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 27 Jan 2026 01:36:44 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F2BA8E808
	for <lists+live-patching@lfdr.de>; Tue, 27 Jan 2026 01:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BCBE8300AB03
	for <lists+live-patching@lfdr.de>; Tue, 27 Jan 2026 00:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AFF51D6195;
	Tue, 27 Jan 2026 00:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c7ISF3e9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEDB1C862E
	for <live-patching@vger.kernel.org>; Tue, 27 Jan 2026 00:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769474201; cv=none; b=i3DeVILnTf4NGA2MBtrZ7Syn1fckZp0n2D3BJYavFXA5JCxhRCSUu72hRTsLHPH+OnnfjoDnRLsyryIsZkgUexMOha9cFEWyS8H4ugoWPIZKZeP1b0UZAGViQKT0eWwlQN4m5V+jhL046bfyChu6YpKjsph5bQhbidi9+qeWgLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769474201; c=relaxed/simple;
	bh=Tde5lIHIdAXtg0kzgPIEeoItrdwavRVJApjbt8ohNxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DpFGrx64WoT0NTWSEf0hT4SEvCxuVFKhwSFAaL3+FpMqDcYBkADqvRVR9nvzxiil9G691M9ROdKOQ/Syr2Tcn/xO6EzfbodJxqRLBvDUfEsBDCZaI9LDSVl8TztIaS+aE0JEm8ewGKFGeto1fZSZh6Q3QjGsqwDNAmU00ZL1LVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c7ISF3e9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE72C16AAE
	for <live-patching@vger.kernel.org>; Tue, 27 Jan 2026 00:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769474200;
	bh=Tde5lIHIdAXtg0kzgPIEeoItrdwavRVJApjbt8ohNxU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=c7ISF3e9xJsqjlPssSP9/d+FnshPEqrrdiPeFWFpBRioPRIxa4bYuaLvGYmyVTyV2
	 o06SuXvinqGIdafq8g7B5wVP+xINAC+uXjiWOsuzYSzY6H7RDVHq+uaWlX24HWFZm7
	 QI2/v8JDH+TNT4hz4r0X3URbQzmUIyuistFFYOjcwW5UZkDmVCVr+n7r6ooqY5p7pg
	 LjjPezQ71qAU95r4CRU1T5dYo3EG7y6PzIG1Dn5anIvrXEYFbxvZM8O4bCjDSQ9uXh
	 qhSKjrmtyCdPHkmBCk0GNm1wrAQ7p0vbEHYvt3jqUJHVUlgEP0+cdhk5jPY3fVYdU9
	 W4mQgag/o6WhA==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-88888d80590so87800226d6.3
        for <live-patching@vger.kernel.org>; Mon, 26 Jan 2026 16:36:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVldqvninRPS4fdkZsWcSCih+d/+UQE4Fh/qkQO++bgrqozz+YmJ/3RBqos87TK9b6q3hCbk4e82ZC9zAQH@vger.kernel.org
X-Gm-Message-State: AOJu0YylAqq8qV3vAgRE481V4ENE9SBopfHZ9ggvT3yPnXUHt3IgBMTv
	TmGU/jpABOZkYb54NM9C4ykwGdCLQ8k3tapCNhkExcaqiol8ZuKQCmfTVGXW/ziOukNAkxpfXov
	eEnDxZTgzET/1Esd7o9Lvgg15aleejDw=
X-Received: by 2002:a05:6214:da5:b0:889:a88f:f01f with SMTP id
 6a1803df08f44-894cc9911b3mr285766d6.61.1769474199848; Mon, 26 Jan 2026
 16:36:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c41b6629e02775e4c1015259aa36065b3fe2f0f3.1769471792.git.jpoimboe@kernel.org>
In-Reply-To: <c41b6629e02775e4c1015259aa36065b3fe2f0f3.1769471792.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Mon, 26 Jan 2026 16:36:27 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4g=9Endyxz5gOHWK2M8+CCP4C7_bobPtansMKdm2vn_w@mail.gmail.com>
X-Gm-Features: AZwV_QhEwYpScWbX0-PyclSkija3ELmrHAB42BmNSqp6Dho6a26aOrSgg6iZTPw
Message-ID: <CAPhsuW4g=9Endyxz5gOHWK2M8+CCP4C7_bobPtansMKdm2vn_w@mail.gmail.com>
Subject: Re: [PATCH] livepatch/klp-build: Fix klp-build vs CONFIG_MODULE_SRCVERSION_ALL
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
	Puranjay Mohan <puranjay@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1925-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 7F2BA8E808
X-Rspamd-Action: no action

On Mon, Jan 26, 2026 at 3:56=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> When building a patch to a single-file kernel module with
> CONFIG_MODULE_SRCVERSION_ALL enabled, the klp-build module link fails in
> modpost:
>
>   Diffing objects
>   drivers/md/raid0.o: changed function: raid0_run
>   Building patch module: livepatch-0001-patch-raid0_run.ko
>   drivers/md/raid0.c: No such file or directory
>   ...
>
> The problem here is that klp-build copied drivers/md/.raid0.o.cmd to the
> module build directory, but it didn't also copy over the input source
> file listed in the .cmd file:
>
>   source_drivers/md/raid0.o :=3D drivers/md/raid0.c
>
> So modpost dies due to the missing .c file which is needed for
> calculating checksums for CONFIG_MODULE_SRCVERSION_ALL.
>
> Instead of copying the original .cmd file, just create an empty one.
> Modpost only requires that it exists.  The original object's build
> dependencies are irrelevant for the frankenobjects used by klp-build.
>
> Fixes: 24ebfcd65a87 ("livepatch/klp-build: Introduce klp-build script for=
 generating livepatch modules")
> Reported-by: Song Liu <song@kernel.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Tested-by: Song Liu <song@kernel.org>

Thanks for the fix!

