Return-Path: <live-patching+bounces-770-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3D3D9CF286
	for <lists+live-patching@lfdr.de>; Fri, 15 Nov 2024 18:14:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8433528DE49
	for <lists+live-patching@lfdr.de>; Fri, 15 Nov 2024 17:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3141D5CF2;
	Fri, 15 Nov 2024 17:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SkhB+am1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413871D5173
	for <live-patching@vger.kernel.org>; Fri, 15 Nov 2024 17:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731690852; cv=none; b=ptlclTnJ4GwFWIJlUOXcIAljPmTEOhgFxJRJse1zc/AwiNJS8GJryFtYCBTvyM88GZYSW/H7z0reo6WL0m2grdVL86FRLH1Tt4IBoGsHjybcbNUgLfGDtP9CvWjoPSPgZ3sn9Oz9tNtLfexa9+HmLjC8pvoStGm+ZEJYKy7L1lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731690852; c=relaxed/simple;
	bh=xe2YCtcX9ilx+J/zhJYk3W+EJiFx/fVLUDUM1MHY51E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hmpDuA7Jo+hv4AbRDeBplJoU3wBmCJOKRfcFaaJ3WPvw9AOuqSBMGMtkxd6XNCyY+cMtMA/FXO/fAR3sj+EHzlt5yLOSIo63Emo8ZF7NbtZ3QoV7RyXSxVs1MSOsl8QszBJCRH8CyczbYIwH31BEqhuUVi5rbFnPK4kEi7IXAoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SkhB+am1; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-38221c82827so1126406f8f.3
        for <live-patching@vger.kernel.org>; Fri, 15 Nov 2024 09:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731690848; x=1732295648; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bBhRJC3YYfm7gt3zgLGDXyOzCWCO53ZfJKUiZkiERp4=;
        b=SkhB+am1QVXoCT+2J9eV7kY+ecF9SCSKXg7y80NUnxY8PFu8TSjtLz37ir+ys/piSW
         aBpmYr8qGxkpnS1qh7pZz3MKYZ4uaFwRo11R0o3ekxsKydOKIq47erkEMs4IZluuyHYn
         Oj4kg0ahnVpZ8gwl/SmfZ4YLbQC17W6pHmphtCqehUDR/RGdgDDvW9MT5bIHYF58YC0o
         IxeweoICMPNLqv8XUYYlDkPwhPqca94QUpjaEh5vsY82b+8xyGwvr5Cu1hCXLKCISEgv
         RDM02lY9gJiuQaNZQm1i+KpQ2ytSq/BWTH8V+zBs6fZekmhV0koTVe+JaAqakuZYaDtc
         pPGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731690848; x=1732295648;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBhRJC3YYfm7gt3zgLGDXyOzCWCO53ZfJKUiZkiERp4=;
        b=NncUTbZOPio7lAY84MwMyxV8EuvfGFyvRbtvf7E7WwcytW3NRAi/5o3tiFYMktYTlG
         IKSQr0XZe0GjkIXOVTZBfZfy4Yn7GD96T23la812t4mYaEHSd8HWnh9Xf9IlQev/LlEZ
         xRvzjQgg7nyUcTmfeuqz9yZNDsUBoBATgQyvHVSZD9vHxvUkjhhm72plMGXzrPrG5J/L
         OWRQQga/JGVLw8E/tl196HOEWRpQU1f2aJfI0dqwIcSkMvwrB7DVoxHcBD4azIuY8poS
         gDjv1SaSd3/E9H3U5V+i1eHGusMOdkLtNZ5EEgSSfbGx7XUAv1bqRIUlHPZLOp3CZ5yE
         8DnA==
X-Forwarded-Encrypted: i=1; AJvYcCXWGjXOoIO4Y63TRiV56yr5uULlZeQ2QLQwih3nwty9k5A6tVLw/4owZmI5EXJL7iINAveUEIcigjo600MX@vger.kernel.org
X-Gm-Message-State: AOJu0YwS2LJ9DLzVUi3T4zB+8V4Y6LvBUT0ZsZMe7SIV6sZTjYA5UOct
	5Mlj5v28Qy9kRoOlG0zd3TP9izAjbsgMf52mmUt0/5NG/rU460ca75Inh+FoQYQ=
X-Google-Smtp-Source: AGHT+IHBhyqcpdNrxuifDtQggFsMRrVDvZ+EVK4nIQIaBJkyeNLUa/StPRUsnluLzs6nkaN5ncI6mA==
X-Received: by 2002:a05:6000:460d:b0:382:1aee:82a7 with SMTP id ffacd0b85a97d-38225a8945emr3095988f8f.40.1731690848444;
        Fri, 15 Nov 2024 09:14:08 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821b31d9ccsm4741618f8f.99.2024.11.15.09.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 09:14:08 -0800 (PST)
Date: Fri, 15 Nov 2024 18:14:05 +0100
From: Petr Mladek <pmladek@suse.com>
To: Siddharth Menon <simeddon@gmail.com>
Cc: shuah@kernel.org, jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	Shuah Khan <skhan@linuxfoundation.org>,
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/livepatch: Check if CONFIG_LIVEPATCH is enabled
Message-ID: <ZzeBXRjWq4vBdaCE@pathway.suse.cz>
References: <20241106174120.5602-1-simeddon@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106174120.5602-1-simeddon@gmail.com>

On Wed 2024-11-06 23:11:20, Siddharth Menon wrote:
> When CONFIG_LIVEPATCH is disabled, compilation fails due to the
> required structs from the livepatch header file being undefined.
> This checks for CONFIG_LIVEPATCH in order to verify that
> it is enabled before compiling livepatch self-tests.
> 
> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Siddharth Menon <simeddon@gmail.com>
> ---
>  tools/testing/selftests/livepatch/test_modules/Makefile | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/livepatch/test_modules/Makefile b/tools/testing/selftests/livepatch/test_modules/Makefile
> index e6e638c4bcba..b34b80544709 100644
> --- a/tools/testing/selftests/livepatch/test_modules/Makefile
> +++ b/tools/testing/selftests/livepatch/test_modules/Makefile
> @@ -1,5 +1,6 @@
>  TESTMODS_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
>  KDIR ?= /lib/modules/$(shell uname -r)/build
> +CONFIG_LIVEPATCH := $(shell cd $(KDIR) && scripts/config --state CONFIG_LIVEPATCH)
>  
>  obj-m += test_klp_atomic_replace.o \
>  	test_klp_callbacks_busy.o \
> @@ -13,10 +14,15 @@ obj-m += test_klp_atomic_replace.o \
>  	test_klp_shadow_vars.o \
>  	test_klp_syscall.o
>  
> -# Ensure that KDIR exists, otherwise skip the compilation
> +
> +# Ensure that KDIR exists and CONFIG_LIVEPATCH is enabled, else skip compilation
>  modules:
>  ifneq ("$(wildcard $(KDIR))", "")
> +ifneq ($(filter y m,$(CONFIG_LIVEPATCH)),)
>  	$(Q)$(MAKE) -C $(KDIR) modules KBUILD_EXTMOD=$(TESTMODS_DIR)
> +else
> +    $(warning CONFIG_LIVEPATCH is not enabled in the kernel config file.)
> +endif
>  endif

This handles only the build of the modules.

It does not block building the test_klp-call_getpid binary.
Also it does not block running the tests, so I get:

tools/testing/selftests/livepatch # make run_tests 
  CC       test_klp-call_getpid
Makefile:24: CONFIG_LIVEPATCH is not enabled in the kernel config file.
make[1]: Nothing to be done for 'modules'.
TAP version 13
1..7
# timeout set to 0
# selftests: livepatch: test-livepatch.sh
# TEST: basic function patching ... ERROR: Can't find "test_modules/test_klp_livepatch.ko", try "make"
not ok 1 selftests: livepatch: test-livepatch.sh # exit=1
# timeout set to 0
# selftests: livepatch: test-callbacks.sh
# TEST: target module before livepatch ... ERROR: Can't find "test_modules/test_klp_callbacks_mod.ko", try "make"
not ok 2 selftests: livepatch: test-callbacks.sh # exit=1
...


I like idea mentioned in Miroslav's reply. I wonder if the check
could take into account all CONFIG_* variables mentioned
in tools/testing/selftests/livepatch/config.

And if it could be generic so that it works for all
tools/testing/selftests/<project> directories.

And for both build and run_tests.

Best Regards,
Petr

