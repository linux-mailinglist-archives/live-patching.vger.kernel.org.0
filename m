Return-Path: <live-patching+bounces-511-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E1C95CBE7
	for <lists+live-patching@lfdr.de>; Fri, 23 Aug 2024 14:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C29F1F226D1
	for <lists+live-patching@lfdr.de>; Fri, 23 Aug 2024 12:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD13183CD4;
	Fri, 23 Aug 2024 12:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MnoyYbWH"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D3215FD13
	for <live-patching@vger.kernel.org>; Fri, 23 Aug 2024 12:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724414427; cv=none; b=p0uVLPwwKIOFSFHmlZwlKhb/gNJ3qLmU/9eC78liZZgC46k8W0vrjBcWftvI8MJrzJJCc8E6PXgInYV3FhcIgAMyZ4oN6CdkBgKW5nJkGfatzdvp6t5clwTFFtrg1B9VFVDUJNyW8cUaQ1Kk42sD2Ulq+BMQa5mGgxQpXw0iYdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724414427; c=relaxed/simple;
	bh=qeCdohfNKomYDIhCdQ65hVd7YI0uAh/eKFSlmg3Rfq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gTse+je8F5Yvy4546hmn4yLXd52mvy1KEqu47VCkxA70UsqwaxIrlal9QKsX66wxtCfjaO+sAyxsvGFpUjCvlobGIZSFKw4YmgEVVgd5NYHqKT1IrKFNY5xqoMEobpwybqP5RPAJ7Bmj5BnN1XD0cKRi/r4Q5pOcRU/0x5sMdes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MnoyYbWH; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5a10835487fso3088635a12.1
        for <live-patching@vger.kernel.org>; Fri, 23 Aug 2024 05:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724414423; x=1725019223; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OfSWPtf3RmlBd/B5tnQdHuIxqsHu2bUSg3Sj9mBLX74=;
        b=MnoyYbWHn18OWLWNwFVDfixNOUV97IhYijuXq4scMobYctcO1OhGIqL5jV3EdhfAZ7
         1qSjXAU9LUYMMA2kPqp6G66Gs1J+TYY5bGk1sVQMKUifG2pQ/0oTCDvcJoqRl8s0SJVx
         aT6FtDF+uTa6izKJcqPiXcuj/nINlYT7x29TLMdKrIgaM2UyLiSESU4TDdDlp1+oEmty
         afR0y3L59OIX5+GC2B8PqJZW/sRzS6HeefHjFXg8T30DK9bnPCABbloMGkspwKYK8Mhc
         SF+ReKz25sJoYl/VWgI3/vtfDyxxdxH/i3LM51lyYz5n8ZqZUf0tTtRJsWokwAGRXKMn
         BXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724414423; x=1725019223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfSWPtf3RmlBd/B5tnQdHuIxqsHu2bUSg3Sj9mBLX74=;
        b=NU9hSs33016pWgS8w7ZWchuBr+T9QvUYNK21LCNS3/xVNj+0LDB/uRICVPJVNg0Pg6
         UzKhTM2a9mXdGHZ4M+YHgondRp+sC25NALAw3KrbYJqLJgHDEPe6Iw0pKvbU2Nblbj6Q
         B85q3RUtpVMm6AxvzwGAKyw90zR6nTGEAs8bVy/q4u4gwg14X9gq9Pvy2lTy7Xc7iL25
         Uon4P+xaX5PbmLf0+Tggjss+VStM5du1uI31POyzHWSR7eMed0m9fdqBQ97l/xaneSLc
         4fBLWT48j89qc+dOL+YmK7YuMe+kiKkT3h38QwTcLnOs1JYyw7U/Mbsk/fr4yYbbtTxt
         To2A==
X-Gm-Message-State: AOJu0Yy5Hf7cJLSJSe2MfWJKCNabkzHrHhd48YawxrJ5Uqy8v0VA/Q5I
	2v8viKTEqI/QyTy+stCs3Fvp5DeeJumbvIdOfwaFauM0JQKNuiqE+yPKoR7ogDk=
X-Google-Smtp-Source: AGHT+IHLrig4hHkD0wjnum9V4jAxJCtug0aQmZ4mjmSi8jKUrUcTrzRc+AOW/bLKhjHYLF1VjvH/zA==
X-Received: by 2002:a05:6402:90b:b0:5bf:157:3b5b with SMTP id 4fb4d7f45d1cf-5c0891690f4mr1556904a12.16.1724414423284;
        Fri, 23 Aug 2024 05:00:23 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c04a4c9322sm1999971a12.60.2024.08.23.05.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 05:00:22 -0700 (PDT)
Date: Fri, 23 Aug 2024 14:00:21 +0200
From: Petr Mladek <pmladek@suse.com>
To: Ryan Sullivan <rysulliv@redhat.com>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, shuah@kernel.org
Subject: Re: [PATCH] selftests/livepatch: wait for atomic replace to occur
Message-ID: <Zsh51f3-n842TZHw@pathway.suse.cz>
References: <20240822173122.14760-1-rysulliv@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822173122.14760-1-rysulliv@redhat.com>

Hi,

this is 2nd version of the patch. There should have been used
[PATCH v2] in the Subject to make it clear in the mailbox.

On Thu 2024-08-22 13:31:22, Ryan Sullivan wrote:
> On some machines with a large number of CPUs there is a sizable delay
> between an atomic replace occurring and when sysfs updates accordingly.
> This fix uses 'loop_until' to wait for the atomic replace to unload all
> previous livepatches.
> 

I think that Joe suggested to add:

Reported-by: CKI Project <cki-project@redhat.com>
Closes: https://datawarehouse.cki-project.org/kcidb/tests/redhat:1413102084-x86_64-kernel_upt_28

> Signed-off-by: Ryan Sullivan <rysulliv@redhat.com>
> ---

Also it is a good practice to summarize changes between versions.
In this case it would have been something like:

Changes against v1:

  - Cleaned the commit message.

>  tools/testing/selftests/livepatch/test-livepatch.sh | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
> index 65c9c058458d..bd13257bfdfe 100755
> --- a/tools/testing/selftests/livepatch/test-livepatch.sh
> +++ b/tools/testing/selftests/livepatch/test-livepatch.sh
> @@ -139,11 +139,8 @@ load_lp $MOD_REPLACE replace=1
>  grep 'live patched' /proc/cmdline > /dev/kmsg
>  grep 'live patched' /proc/meminfo > /dev/kmsg
>  
> -mods=(/sys/kernel/livepatch/*)
> -nmods=${#mods[@]}
> -if [ "$nmods" -ne 1 ]; then
> -	die "Expecting only one moduled listed, found $nmods"
> -fi
> +loop_until 'mods=(/sys/kernel/livepatch/*); nmods=${#mods[@]}; [[ "$nmods" -eq 1 ]]' ||
> +        die "Expecting only one moduled listed, found $nmods"
>  
>  # These modules were disabled by the atomic replace
>  for mod in $MOD_LIVEPATCH3 $MOD_LIVEPATCH2 $MOD_LIVEPATCH1; do

Otherwise, it looks good to me. With the added references:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

PS: No need to resend the patch. I would add the references when
    committing. I am going to wait few more days before committing.

