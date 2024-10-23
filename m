Return-Path: <live-patching+bounces-751-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8663A9ACA25
	for <lists+live-patching@lfdr.de>; Wed, 23 Oct 2024 14:38:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F3842835A1
	for <lists+live-patching@lfdr.de>; Wed, 23 Oct 2024 12:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10921AB539;
	Wed, 23 Oct 2024 12:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TlbF2BZv"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E7D3FD4
	for <live-patching@vger.kernel.org>; Wed, 23 Oct 2024 12:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729687098; cv=none; b=lMjMMMVOA5Yxx7+lbtLPUhEw4w4XDxlynEWJzbgWeR3MiXrU8uFG7x2bk8Wu86c8P2KO+R2Ds0OvcrC7/pj9z0x+AXLpUkpaBGcRb6bgd4wOJQpnFY1foqB5NkOIkZgrT7WjcpttSQk5uTXmVraLros6jasUv6KID5Tc2WOeUlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729687098; c=relaxed/simple;
	bh=Pu2nrpOTouRjv0rl8mdMkLOx1mu2ZRdyvoO9H1ikB6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JHuWIEhacVok9WughftjAuATOkn5pQUwNMSqlriMY3RX2U4renuVpyDW/ytJfjTKAJpD3EBY5PTsWjd2akb4Egg+u1xIxDqjqguEo+LVn72JzWkLq/1fR5D18S8GrC0/JY3L2avtMxOCV129YysvYrUFCBahOb42jowDCofnn2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TlbF2BZv; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43168d9c6c9so48277725e9.3
        for <live-patching@vger.kernel.org>; Wed, 23 Oct 2024 05:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1729687095; x=1730291895; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XmNJ4njEEpOrmBT0rUaUQn7lrkfzlys5UMDexBH3nfs=;
        b=TlbF2BZvj0fRCX15aRi0H+gR0EKgk6brNcAKy5QBwoBokwzRGKm0PToXPYfHtvz216
         acmiAGGGF1ZpeTRlrGlUrgfa4p8rJkPMKjaZYdne6+igHtOT7nMBgLb/tR06ZkqdaV/M
         nQ2Fce9FN3EJfhfcAR1GAKhYoDveoQJSp2/D+okG5XhyeQLTulp0M+D3+MwZLsrJqlSR
         z0n1VEWRds2fzJKHi+dIHoS7LiGGMFNwvyrz61gq01i0cWp+wjy1y9yICscceEnvcEFv
         0/36HZwCD0YlmxNXXE9D74tnPCddjHEP3yZZbafE2h09zsArs/Am/Tjmx9TJjCm0luRC
         HAqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729687095; x=1730291895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XmNJ4njEEpOrmBT0rUaUQn7lrkfzlys5UMDexBH3nfs=;
        b=jFE69uALWHtV8S5IYMpIeOFBxMgITAqpMoHJ/NsJQbv9Zq49pyCYm2ut3Nx0pEenuH
         XF53oRTJ0+0lHIgmQU0RnQmxOBzj2TYGvP1LCj/z072EaQPIbKHMpEaY0fmrKrgQcwo+
         b8oJkeIszXCkjRZKhTE4GfiNH2iQxC44UHKwORJu6gV1PFLoy/iKakdeRkL80lPwUJ6k
         Tpt7aZj/MKhQWkZJUDLVlYCwKD9nGWL7SgZfl+qWQjkExlUZQ0GajKXSjN3hmC9rGBNI
         9Sfu5o/KQZ2HjdDziJyie9tTMf6G5n2ovgJw9kVXju2szMaWeCn/2Mfb14NQjGEDOPjq
         Ssdw==
X-Forwarded-Encrypted: i=1; AJvYcCUsGCc7TTEk8zuj2AzT1VD6Mn6F7nDgyEdLhlGDSLpH8ptQKljA9eIgmK/48+UcxKQeDaH8y52suM+N2DqP@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl0KDYqO3ebZ+9cSWEvYf24Nx9Gas8DPAs5wrlyVMGVwjVgJCp
	Of0HXhqZAWKtG+DZk0Whn+O85OjHyvhZXelfq2q1TX82y564aIlW2pi1d+CSN5M=
X-Google-Smtp-Source: AGHT+IFEvaEt508ZqXpALfvO8BSsPc1mq8mVN8QU2yBaJIoYVt6b+a0GOubHuoCGMmfjx1dXbPfw2Q==
X-Received: by 2002:a05:600c:45cb:b0:431:44aa:ee2e with SMTP id 5b1f17b1804b1-4318413209emr18520915e9.4.1729687094847;
        Wed, 23 Oct 2024 05:38:14 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43186bdeb4asm15171225e9.15.2024.10.23.05.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 05:38:14 -0700 (PDT)
Date: Wed, 23 Oct 2024 14:38:12 +0200
From: Petr Mladek <pmladek@suse.com>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: livepatch: add test cases of stack_order
 sysfs interface
Message-ID: <ZxjuNBidriSwWw8L@pathway.suse.cz>
References: <20241011151151.67869-1-zhangwarden@gmail.com>
 <20241011151151.67869-2-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011151151.67869-2-zhangwarden@gmail.com>

On Fri 2024-10-11 23:11:51, Wardenjohn wrote:
> Add selftest test cases to sysfs attribute 'stack_order'.
> 
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> ---
>  .../testing/selftests/livepatch/test-sysfs.sh | 74 +++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
> index 05a14f5a7bfb..71a2e95636b1 100755
> --- a/tools/testing/selftests/livepatch/test-sysfs.sh
> +++ b/tools/testing/selftests/livepatch/test-sysfs.sh
> @@ -5,6 +5,8 @@
>  . $(dirname $0)/functions.sh
>  
>  MOD_LIVEPATCH=test_klp_livepatch
> +MOD_LIVEPATCH2=test_klp_callbacks_demo
> +MOD_LIVEPATCH3=test_klp_syscall
>  
>  setup_config
>  
> @@ -131,4 +133,76 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
>  livepatch: '$MOD_LIVEPATCH': unpatching complete
>  % rmmod $MOD_LIVEPATCH"
>  
> +start_test "sysfs test stack_order read"

s/read/value/

> +
> +load_lp $MOD_LIVEPATCH
> +
> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"

The access rights should be rather tested in the 1st test in
test-sysfs.sh. We do not need to check it repeatedly here.

> +check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
> +
> +load_lp $MOD_LIVEPATCH2
> +
> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"

Same here...

> +check_sysfs_value  "$MOD_LIVEPATCH2" "stack_order" "2"
> +
> +load_lp $MOD_LIVEPATCH3
> +
> +check_sysfs_rights "$MOD_LIVEPATCH3" "stack_order" "-r--r--r--"
> +check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "3"
> +
> +disable_lp $MOD_LIVEPATCH2
> +unload_lp $MOD_LIVEPATCH2
> +
> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
> +check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
> +check_sysfs_rights "$MOD_LIVEPATCH3" "stack_order" "-r--r--r--"
> +check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "2"
> +
> +disable_lp $MOD_LIVEPATCH3
> +unload_lp $MOD_LIVEPATCH3
> +
> +disable_lp $MOD_LIVEPATCH
> +unload_lp $MOD_LIVEPATCH

Otherwise, it looks good to me.

Just to make it clear, I suggest to do the following changes:

diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
index 71a2e95636b1..e44a051be307 100755
--- a/tools/testing/selftests/livepatch/test-sysfs.sh
+++ b/tools/testing/selftests/livepatch/test-sysfs.sh
@@ -21,6 +21,8 @@ check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
 check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
+check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
+check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
 check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
 check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
@@ -133,29 +135,24 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
 livepatch: '$MOD_LIVEPATCH': unpatching complete
 % rmmod $MOD_LIVEPATCH"
 
-start_test "sysfs test stack_order read"
+start_test "sysfs test stack_order value"
 
 load_lp $MOD_LIVEPATCH
 
-check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
 
 load_lp $MOD_LIVEPATCH2
 
-check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH2" "stack_order" "2"
 
 load_lp $MOD_LIVEPATCH3
 
-check_sysfs_rights "$MOD_LIVEPATCH3" "stack_order" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "3"
 
 disable_lp $MOD_LIVEPATCH2
 unload_lp $MOD_LIVEPATCH2
 
-check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
-check_sysfs_rights "$MOD_LIVEPATCH3" "stack_order" "-r--r--r--"
 check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "2"
 
 disable_lp $MOD_LIVEPATCH3


With the above changes:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Please, try to send the next version together with the patch adding
the "stack_order" attribute.

Best Regards,
Petr

