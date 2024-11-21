Return-Path: <live-patching+bounces-855-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEFA19D454E
	for <lists+live-patching@lfdr.de>; Thu, 21 Nov 2024 02:36:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 469FFB21EA5
	for <lists+live-patching@lfdr.de>; Thu, 21 Nov 2024 01:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210D99474;
	Thu, 21 Nov 2024 01:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYucG0++"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F52719A;
	Thu, 21 Nov 2024 01:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732153006; cv=none; b=lwbTsxfkQOadmHMX3+Z3ehKxh3J02l5ZDYqgMfvmHVVFQssnP2xs/youelNfo3nvltLs87TSV6PgfdTi73mLoTDKrc87mdf+ID975L6LWz7s/NmA9Ce62n0gmL4PbaLgu/I0nTzOplUvOQw1AkECbC2iWPNdDad4FEXCGqw5vsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732153006; c=relaxed/simple;
	bh=g3Z3B4+ahzCJQmWUhzm8VXWkQS1OUZc9o2n9s7IYGdc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=eu1N/Q1QMsgLuYJHVH2dhcJuM5koPJ8/moXNNOH2wd3Q/bzzILw/Mv56nFQVAZOgnvpHUjfP8YDbVVuxmPTh+I0vq6EpyOKSzstVrgjC+nDNMwYggpuwOJ3Fw7a9rCeoxas+n19sEg/cHME9SvL7uIjjXVkvMur4URDA14iKFuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nYucG0++; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7fbb47b1556so280504a12.0;
        Wed, 20 Nov 2024 17:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732153004; x=1732757804; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iDIdDARj6chowZd9UqB5N0LI7no7eIEOQkkAwjkWPRI=;
        b=nYucG0++Qo1Wx7n/kieGHGu3vWWXhUefcJv2RIRd5DiFikcfDFjC9AmMcogU0ShGp2
         8wfTIyN2kdlKWYLk8UIcnmEwIC6EusFfp5mzEJqiyXTtslArFJHODh8I+wQbymXJNLJv
         yS3o2C3Nq/KlAdpGyrCLXprIoB1pV2g6fRArO75kcHsUxPbUNvad96ba7BMQ5y3d06e/
         E9acVOecMYOLIIfF6XqlUyrm6fgs3m0tJftTZl7PuZQpf/K/PpHfQWy9C9pvavZv+MWx
         0QXBjFUbJaqcCPMbPaVk+xp74nx96bY752BiHZK2s4y0Pr1tE6JU95lgHW+eIWquSyNx
         nwyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732153004; x=1732757804;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iDIdDARj6chowZd9UqB5N0LI7no7eIEOQkkAwjkWPRI=;
        b=P47tX+aNu0Sse3ZNTv3wWPrjyq5mNbVtPArjBY7anxXcIkxbTVc1IKaysub1bF9Srd
         ErgoXxLd2n3r03N6dtsoK4sJ6rJI1/ZATG1xlDFraqvNPyldkBzKa+vx15+IWkerqd+A
         M4wk0gPgBOWddh6h8CIPjtr+NRd6czFFU2j/B1ay1tN2C0a1iyOT81fYERbAeMD1qh+2
         bvw7ed0MCIlSEpGdhE10CogFC7SiEWzXHiJMRlqFi95Kc79Yjb92lv2hoHhjMb7/USys
         wpkV4bQmEWin0QfnrBYp9TTVbH8gRvRm0XefDX6ksxPHugWlnim3KsW7spZ+xRidPGGY
         jN0g==
X-Forwarded-Encrypted: i=1; AJvYcCVnU6rfHiiRAxnUHYY7kuIB0PkxygC+m7J3/BiMMJE54ygFAmx9S6GCzfhaTbSV09MH24YFKRlbQYH7VGs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBuzr2gfbbb0ekWbJytKL8jFaEYW7C8oZVU6C468TIoo6Mpt04
	jfYB3boi5/iPuQBI+hvGZ1jeRRlhS+5JmG+A55VqfwAt91RBNDKL
X-Google-Smtp-Source: AGHT+IHeFnz7miwRgA/C3xTsDp+jGzVOv2q2XaleKGTM5pI1wqGKirYEuoWLDY5LFpm+ZoHlyu+b/w==
X-Received: by 2002:a17:90b:124d:b0:2ea:9e36:980e with SMTP id 98e67ed59e1d1-2eaebf051a0mr2372399a91.13.1732153003646;
        Wed, 20 Nov 2024 17:36:43 -0800 (PST)
Received: from smtpclient.apple ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21287ee2a12sm2104435ad.157.2024.11.20.17.36.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Nov 2024 17:36:43 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH V3] selftests: livepatch: add test cases of stack_order
 sysfs interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20241024083530.58775-1-zhangwarden@gmail.com>
Date: Thu, 21 Nov 2024 09:36:25 +0800
Cc: live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CD7BF255-7128-412C-86EB-305CEC7FF2B7@gmail.com>
References: <20241024083530.58775-1-zhangwarden@gmail.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Oct 24, 2024, at 16:35, Wardenjohn <zhangwarden@gmail.com> wrote:
>=20
> Add selftest test cases to sysfs attribute 'stack_order'.
>=20
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> ---
> .../testing/selftests/livepatch/test-sysfs.sh | 71 +++++++++++++++++++
> 1 file changed, 71 insertions(+)
>=20
> diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh =
b/tools/testing/selftests/livepatch/test-sysfs.sh
> index 05a14f5a7bfb..e44a051be307 100755
> --- a/tools/testing/selftests/livepatch/test-sysfs.sh
> +++ b/tools/testing/selftests/livepatch/test-sysfs.sh
> @@ -5,6 +5,8 @@
> . $(dirname $0)/functions.sh
>=20
> MOD_LIVEPATCH=3Dtest_klp_livepatch
> +MOD_LIVEPATCH2=3Dtest_klp_callbacks_demo
> +MOD_LIVEPATCH3=3Dtest_klp_syscall
>=20
> setup_config
>=20
> @@ -19,6 +21,8 @@ check_sysfs_rights "$MOD_LIVEPATCH" "enabled" =
"-rw-r--r--"
> check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
> check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
> check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
> +check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
> check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
> check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
> check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
> @@ -131,4 +135,71 @@ livepatch: '$MOD_LIVEPATCH': completing =
unpatching transition
> livepatch: '$MOD_LIVEPATCH': unpatching complete
> % rmmod $MOD_LIVEPATCH"
>=20
> +start_test "sysfs test stack_order value"
> +
> +load_lp $MOD_LIVEPATCH
> +
> +check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
> +
> +load_lp $MOD_LIVEPATCH2
> +
> +check_sysfs_value  "$MOD_LIVEPATCH2" "stack_order" "2"
> +
> +load_lp $MOD_LIVEPATCH3
> +
> +check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "3"
> +
> +disable_lp $MOD_LIVEPATCH2
> +unload_lp $MOD_LIVEPATCH2
> +
> +check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
> +check_sysfs_value  "$MOD_LIVEPATCH3" "stack_order" "2"
> +
> +disable_lp $MOD_LIVEPATCH3
> +unload_lp $MOD_LIVEPATCH3
> +
> +disable_lp $MOD_LIVEPATCH
> +unload_lp $MOD_LIVEPATCH
> +
> +check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH'
> +livepatch: '$MOD_LIVEPATCH': initializing patching transition
> +livepatch: '$MOD_LIVEPATCH': starting patching transition
> +livepatch: '$MOD_LIVEPATCH': completing patching transition
> +livepatch: '$MOD_LIVEPATCH': patching complete
> +% insmod test_modules/$MOD_LIVEPATCH2.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH2'
> +livepatch: '$MOD_LIVEPATCH2': initializing patching transition
> +$MOD_LIVEPATCH2: pre_patch_callback: vmlinux
> +livepatch: '$MOD_LIVEPATCH2': starting patching transition
> +livepatch: '$MOD_LIVEPATCH2': completing patching transition
> +$MOD_LIVEPATCH2: post_patch_callback: vmlinux
> +livepatch: '$MOD_LIVEPATCH2': patching complete
> +% insmod test_modules/$MOD_LIVEPATCH3.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH3'
> +livepatch: '$MOD_LIVEPATCH3': initializing patching transition
> +livepatch: '$MOD_LIVEPATCH3': starting patching transition
> +livepatch: '$MOD_LIVEPATCH3': completing patching transition
> +livepatch: '$MOD_LIVEPATCH3': patching complete
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH2/enabled
> +livepatch: '$MOD_LIVEPATCH2': initializing unpatching transition
> +$MOD_LIVEPATCH2: pre_unpatch_callback: vmlinux
> +livepatch: '$MOD_LIVEPATCH2': starting unpatching transition
> +livepatch: '$MOD_LIVEPATCH2': completing unpatching transition
> +$MOD_LIVEPATCH2: post_unpatch_callback: vmlinux
> +livepatch: '$MOD_LIVEPATCH2': unpatching complete
> +% rmmod $MOD_LIVEPATCH2
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH3/enabled
> +livepatch: '$MOD_LIVEPATCH3': initializing unpatching transition
> +livepatch: '$MOD_LIVEPATCH3': starting unpatching transition
> +livepatch: '$MOD_LIVEPATCH3': completing unpatching transition
> +livepatch: '$MOD_LIVEPATCH3': unpatching complete
> +% rmmod $MOD_LIVEPATCH3
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
> +livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
> +livepatch: '$MOD_LIVEPATCH': starting unpatching transition
> +livepatch: '$MOD_LIVEPATCH': completing unpatching transition
> +livepatch: '$MOD_LIVEPATCH': unpatching complete
> +% rmmod $MOD_LIVEPATCH"
> +
> exit 0
> --=20
> 2.43.5
>=20

Hi, Petr.

Here to remind you not to forget this attribute for linux-6.13.

Thanks.
Wardenjohn=

