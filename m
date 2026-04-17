Return-Path: <live-patching+bounces-2383-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uFYyAEBQ4mnx4QAAu9opvQ
	(envelope-from <live-patching+bounces-2383-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 17:22:40 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C73641C871
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 17:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 61CA9301B938
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 15:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04746309EEB;
	Fri, 17 Apr 2026 15:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gcN3Rnay"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4538C2E7179
	for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 15:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776439296; cv=none; b=KvkDuBPhImzARaYGT/D23m+Unqn/a6ggacG2+/FB277yFJ9Ofw4TIIGXxuhUpC38F6emYrsijkYZak4g8Zch8vnVFmfq8yK/PH9xqi2xacG1u6m8ETkgTgD/vulb+FpNpNaCUjc4E025/nZKqeXIN9QhNSXc6ENTpsSG0bHCW+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776439296; c=relaxed/simple;
	bh=M2E1SEG2x3teFg+qnnpPmYuaBrB9R5Rz8c/POQX9mGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRbKgJ+8k3FNwHXtWp5iFhI4EIzJ4bL/htpwSmOZBv5HSAgLq4VbfIAYbFchUpxAVRcTIzgpaxGS/B9LGBIxXmTz39E2ou9MYkg3tTeU8dXFuW30DBlUAq3GLh5kg9SZ/B/P9dcSiaEeEeBFcGpZQyQTWUsIvRPWw9d4Bq150So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gcN3Rnay; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488ba6366a7so10752245e9.0
        for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 08:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776439293; x=1777044093; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OODOXKTFeZzuM+IhLFfzPN4JgrzsLzLiFjK9InyGOt4=;
        b=gcN3RnayPU3dwoDgd2+WTuq7tQ2zuPkVrzXx3tmRzmeDLWmQl28H5xo7MWz3GTMbuu
         ugElV3w/Efh9mfVnTGcXrRYlIm4fjlaeWw7AxBUVf+yDP6Y/4CJzMqzEWI+lCwzC35fw
         VjjgT0XgoHOoakwdEFKVbBDttpce9aX41w3hl08tzQdncxo5NpkQVI4evnWqDmkIJf2l
         y+99YyKDQ/vVWYwY7C7x1lt+xxvYl01zJBgXio9yKpBHF1GEdx1nb8d0EfQuA8buMnop
         AUNSPgQ0nqGZvmVlUFkqIv+dQGOfBy/Sb/BBCY/9z+C4MAgm3Kids8KYXCgMASaeHTnn
         W/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776439293; x=1777044093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OODOXKTFeZzuM+IhLFfzPN4JgrzsLzLiFjK9InyGOt4=;
        b=L40OhZxl4G6qyFzX3UDcggHomKoIBmjDmA3xmiqGPYyQb40L7uJ/29RRK70gCliomv
         PMvhnMfuea2zAFYfGxvj2ZpuJNxQ1BOXCht4w7KA895nD16T6tL2tujKAziJIoC3X0AQ
         fPn0gPnnMz1cdmkDKLFlpk+GOUJoVGathZIaeDgkGp0zzP3a0SKtK4d5xg/2UGqkfOjo
         la64Md2806R2QODypK3GMRriMCReM5OgLat6fn1kioOhHsJ5u+BfVlSS/aB3cBx69tnn
         ZQ3Q60IUkczTkObfrGaT6zwqpAkvTAxiqpEdP9sBy1F1pI1x4aWQFKPQH4uY0NyBb4wj
         qctw==
X-Forwarded-Encrypted: i=1; AFNElJ/5vIW4Jm0tODEGGWFL+H5sZ1D9Poq3Pnfxp5csQm2qMQMsWhzWJrCqYOcKG0BC/hYPXPHmp8YlgUQXbMko@vger.kernel.org
X-Gm-Message-State: AOJu0YyajO2BPVUe1zb2bKS+VU3oJuI9x0CFWuCyULD/YJaPQOqGLZkX
	pHJae7Aarfxrof40Cm5ODYt7dYH3P6WF+2Q76gIOATT6j6VxXgzFWgt/ioSTcfsEV0w=
X-Gm-Gg: AeBDievyQnyA+7xUr59B8j10FUc19pWuddhkoKN373ybknDVOFU0qBq5qcTDrV1FDKx
	o6NnnNWRh3r4DYSMLPWogm0AW6UZIjQttcBQsZY4vK2u6wEA0/2rSUlHGJgFzuxDYh79yGX9xJC
	YQhUhP2XlHwzPJkbG1r71VlMTqDPnjAiIv6z0NEDFyAJi94XVSVLHEDUMIoMSiJ4IvsBxffniw8
	E7kRdtoMYlI30d2LT2QpAvsu7YYwr/ue+iMgGfxEA4tP2zi6dXYUhvAjP6we1RsOpK63bGNTUhK
	8JGWVFR6cAOCXRzWnvjwvLxVPHaaoBzY9bIO9h2N6CMGe4rUNHdqBMTIAdneoWBXCtlDHVsqmkK
	UMcSY8AXVxfDOr8h2fhpOK78fWZS5CpOMbetsXqR67yaUy+yrObyUI3qr3BgEtt6BGEyJJPFUBk
	AoJKlUYCZMp+Xq7IB+m3B5s4BbCsoHLUf6Q+rh
X-Received: by 2002:a05:6000:4201:b0:43e:a72e:ec5a with SMTP id ffacd0b85a97d-43fe3dc62f3mr4962652f8f.20.1776439292473;
        Fri, 17 Apr 2026 08:21:32 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1682sm5378592f8f.1.2026.04.17.08.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 08:21:31 -0700 (PDT)
Date: Fri, 17 Apr 2026 17:21:30 +0200
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] selftests: livepatch: Check if patched sysfs
 attribute exists
Message-ID: <aeJP-tdGdSov3ogP@pathway.suse.cz>
References: <20260413-lp-tests-old-fixes-v2-0-367c7cb5006f@suse.com>
 <20260413-lp-tests-old-fixes-v2-4-367c7cb5006f@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413-lp-tests-old-fixes-v2-4-367c7cb5006f@suse.com>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2383-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,pathway.suse.cz:mid]
X-Rspamd-Queue-Id: 9C73641C871
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon 2026-04-13 14:26:15, Marcos Paulo de Souza wrote:
> In order to run the selftests on older kernels, check if given kernel
> has support for the attribute. If the attribute is not supported, skip
> the checks.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>  tools/testing/selftests/livepatch/test-sysfs.sh | 38 +++++++++++++++----------
>  1 file changed, 23 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
> index 58fe1d96997c..a2d649404a63 100755
> --- a/tools/testing/selftests/livepatch/test-sysfs.sh
> +++ b/tools/testing/selftests/livepatch/test-sysfs.sh
> @@ -8,6 +8,8 @@ MOD_LIVEPATCH=test_klp_livepatch
>  MOD_LIVEPATCH2=test_klp_callbacks_demo
>  MOD_LIVEPATCH3=test_klp_syscall
>  

It would be nice to add a comment in which upstream kernel version
the attribute was introduced. It might help to decide when it is
time to remove the check, see below.

> +HAS_PATCH_ATTR=0
> +
>  setup_config
>  
>  # - load a livepatch and verifies the sysfs entries work as expected
> @@ -25,8 +27,12 @@ check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
>  check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
>  check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
>  check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
> -check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
> -check_sysfs_value  "$MOD_LIVEPATCH" "vmlinux/patched" "1"
> +
> +if does_sysfs_exists "$MOD_LIVEPATCH/vmlinux" "patched"; then
> +	check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
> +	check_sysfs_value  "$MOD_LIVEPATCH" "vmlinux/patched" "1"
> +	HAS_PATCH_ATTR=1
> +fi
>  
>  disable_lp $MOD_LIVEPATCH
>  
> @@ -45,23 +51,24 @@ livepatch: '$MOD_LIVEPATCH': completing unpatching transition
>  livepatch: '$MOD_LIVEPATCH': unpatching complete
>  % rmmod $MOD_LIVEPATCH"
>  
> -start_test "sysfs test object/patched"
> +if [[ "$HAS_PATCH_ATTR" == "1" ]]; then
> +	start_test "sysfs test object/patched"
>  
> -MOD_LIVEPATCH=test_klp_callbacks_demo
> -MOD_TARGET=test_klp_callbacks_mod
> -load_lp $MOD_LIVEPATCH
> +	MOD_LIVEPATCH=test_klp_callbacks_demo
> +	MOD_TARGET=test_klp_callbacks_mod
> +	load_lp $MOD_LIVEPATCH
>  
> -# check the "patch" file changes as target module loads/unloads
> -check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
> -load_mod $MOD_TARGET
> -check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "1"
> -unload_mod $MOD_TARGET
> -check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
> +	# check the "patch" file changes as target module loads/unloads
> +	check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
> +	load_mod $MOD_TARGET
> +	check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "1"
> +	unload_mod $MOD_TARGET
> +	check_sysfs_value  "$MOD_LIVEPATCH" "$MOD_TARGET/patched" "0"
>  
> -disable_lp $MOD_LIVEPATCH
> -unload_lp $MOD_LIVEPATCH
> +	disable_lp $MOD_LIVEPATCH
> +	unload_lp $MOD_LIVEPATCH
>  
> -check_result "% insmod test_modules/test_klp_callbacks_demo.ko
> +	check_result "% insmod test_modules/test_klp_callbacks_demo.ko
>  livepatch: enabling patch 'test_klp_callbacks_demo'
>  livepatch: 'test_klp_callbacks_demo': initializing patching transition
>  test_klp_callbacks_demo: pre_patch_callback: vmlinux
> @@ -87,6 +94,7 @@ livepatch: 'test_klp_callbacks_demo': completing unpatching transition
>  test_klp_callbacks_demo: post_unpatch_callback: vmlinux
>  livepatch: 'test_klp_callbacks_demo': unpatching complete
>  % rmmod test_klp_callbacks_demo"
> +fi

The indentation mismatch (code vs check_results) looks a bit ugly.
Well, it is rather common thing in bash scripts. And it might
even help to find where the next text starts.

I could live with it. But I am a bit biased.

I would like to see an ack from a non-SUSE person before
taking this ;-)

Best Regards,
Petr

PS: Otherwise, the patchset look good to me, modulo
    the Sashiko AI comments.

