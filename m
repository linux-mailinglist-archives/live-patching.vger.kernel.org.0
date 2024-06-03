Return-Path: <live-patching+bounces-314-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C118D87FA
	for <lists+live-patching@lfdr.de>; Mon,  3 Jun 2024 19:32:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB4FF28ACAE
	for <lists+live-patching@lfdr.de>; Mon,  3 Jun 2024 17:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28570137756;
	Mon,  3 Jun 2024 17:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A0tXkFkR"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FB4136E38
	for <live-patching@vger.kernel.org>; Mon,  3 Jun 2024 17:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717435929; cv=none; b=m4NIWNw/GNupPE6jrH7Jlsi5m8ew+UxPwbTeCppT+kmtIbAZnU+xjcUY4sg+ixZIHS+fOqYCYxxvT+NSdsjhAVMdFY3JRzIlScHyTZbIxq5+y1sn6/2qig2l35IKT1Z8unm8sbDCHOCM5yN295yY0sI7WYoPq0c0rh8O/Xf270o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717435929; c=relaxed/simple;
	bh=MAVrEHQznP2/fwWlLae0Zx4RKcm7cpRQzHaeqHjUAco=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pDoNbLLOo+NSkqTAUgZI8mSqlZSpsLl8dtSbp6OQa4FtanJiMmxL2HU2x4SBh21VluhEsmUDALcCQJ8f0fBj69lVK4gubhI32NggJqJZVr+MvpZsIescViWdZdqvnR2BFbx8pfYo8Ijw0gp2bnNcU3RezgceNdnQ9KGvumZ2iz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A0tXkFkR; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2ea903cd11bso48148301fa.1
        for <live-patching@vger.kernel.org>; Mon, 03 Jun 2024 10:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717435925; x=1718040725; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E0chlZzFYNY4NCq9cTKoNOXLnYzWUplu9hQipTbXGuw=;
        b=A0tXkFkRh1xTckeDhLMJnUp3WfEBCr06BlXv2lmX7pJ/qKYIvh9OOLWEZVZSLkPTR5
         nxiFbrmKjZKDUewDK/0qd+I621RED532LWxNwL4G2P6s2WhRLKXWRtuZKIl1uwUSDS3A
         M0nGYiQYeOaL9oQnkoHjs5unNCASvwEnOyzqfsIqSQO3/U1Q6wCLVIxOGUJmUc1xTswn
         pWQ849ZET4DQBGb6pEmkgu4cvrDyma7Q6B+lfRsofe1bSbF+ccScjerZEpJFJiGBGApS
         XZS+5J2R4ONqP+PCUwX+gQ2hQWwVzPclBIm0z1jQG8/LsmQczMOp9o95MVcpc7S2B9Wx
         +WwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717435925; x=1718040725;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E0chlZzFYNY4NCq9cTKoNOXLnYzWUplu9hQipTbXGuw=;
        b=bbegWyQjVctzcu2VdAdJRlXBlSf+MKJ/ykTIR/6Q+cu8Z/tvZenVb4fnSCFwWNDxFb
         sZAoe8Cxe2/D6tGAzXoIlmLEtG5y5xEoCDNg93SbJBVI8ODiOv1zUbcDDwFuvf6RQnrm
         f2c7vxLbi8vG6NDdU98LKGgk09ViHsdVi0Zwewl2SlNgeYoPMfEqrhUVlLjTkIYn2EE2
         Ofv6N738Vpls604Kg/9LIKRxAZsOt2snKOTQk9W85DNNMKibl8tIMEJjwzqy5RkJtWrk
         jRGLS5KiUa7YRUNrXaaS64pquk50+C518976XORE7w3v6G6vRSzQHU79GBZonrasL4ek
         Re7Q==
X-Gm-Message-State: AOJu0YyR9xfRGabqYFvg+2oOIyH+EHshHp6Y+lMkp16sOw7WRG2L3zkr
	CDVBcsNZ1OAl7JPCsYx4o5RIjvCKPA7yKBmvhm5sQyO0t2KtFuq8rFnXfTzlFWw=
X-Google-Smtp-Source: AGHT+IHO8mHadgphKx5sBj6yHPRmiEDtLh4jXTfTdhstov+igBiD7SGsFcw6y5DheFe+02Lz1FxTAw==
X-Received: by 2002:a05:651c:b28:b0:2e9:77ec:58eb with SMTP id 38308e7fff4ca-2ea9512fe77mr85905171fa.17.1717435924946;
        Mon, 03 Jun 2024 10:32:04 -0700 (PDT)
Received: from ?IPv6:2804:5078:851:4000:58f2:fc97:371f:2? ([2804:5078:851:4000:58f2:fc97:371f:2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6c3598487d9sm5620665a12.70.2024.06.03.10.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 10:32:04 -0700 (PDT)
Message-ID: <6e0845f56efcffa8ed1e7ef1c63d20e383614e6d.camel@suse.com>
Subject: Re: [PATCH v3] selftests: livepatch: Test atomic replace against
 multiple modules
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes
	 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Joe Lawrence
	 <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Mon, 03 Jun 2024 14:31:53 -0300
In-Reply-To: <20240603-lp-atomic-replace-v3-1-9f3b8ace5c9f@suse.com>
References: <20240603-lp-atomic-replace-v3-1-9f3b8ace5c9f@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-06-03 at 14:26 -0300, Marcos Paulo de Souza wrote:
> Adapt the current test-livepatch.sh script to account the number of
> applied livepatches and ensure that an atomic replace livepatch
> disables
> all previously applied livepatches.
>=20
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
> Changes since v2:
> * Used variables to stop the name of other livepatches applied to

Typo here :)

s/stop/show
> test
> =C2=A0 the atomic replace. (Joe)




>=20
> Changes since v1:
> * Added checks in the existing test-livepatch.sh instead of creating
> a
> =C2=A0 new test file. (Joe)
> * Fixed issues reported by ShellCheck (Joe)
> ---
> Changes in v3:
> - EDITME: describe what is new in this series revision.
> - EDITME: use bulletpoints and terse descriptions.
> - Link to v2:
> https://lore.kernel.org/r/20240525-lp-atomic-replace-v2-1-142199bb65a1@su=
se.com
> ---
> =C2=A0.../testing/selftests/livepatch/test-livepatch.sh=C2=A0 | 138
> +++++++++++++--------
> =C2=A01 file changed, 89 insertions(+), 49 deletions(-)
>=20
> diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh
> b/tools/testing/selftests/livepatch/test-livepatch.sh
> index e3455a6b1158..ca770b8c62fc 100755
> --- a/tools/testing/selftests/livepatch/test-livepatch.sh
> +++ b/tools/testing/selftests/livepatch/test-livepatch.sh
> @@ -4,7 +4,9 @@
> =C2=A0
> =C2=A0. $(dirname $0)/functions.sh
> =C2=A0
> -MOD_LIVEPATCH=3Dtest_klp_livepatch
> +MOD_LIVEPATCH1=3Dtest_klp_livepatch
> +MOD_LIVEPATCH2=3Dtest_klp_syscall
> +MOD_LIVEPATCH3=3Dtest_klp_callbacks_demo
> =C2=A0MOD_REPLACE=3Dtest_klp_atomic_replace
> =C2=A0
> =C2=A0setup_config
> @@ -16,33 +18,33 @@ setup_config
> =C2=A0
> =C2=A0start_test "basic function patching"
> =C2=A0
> -load_lp $MOD_LIVEPATCH
> +load_lp $MOD_LIVEPATCH1
> =C2=A0
> -if [[ "$(cat /proc/cmdline)" !=3D "$MOD_LIVEPATCH: this has been live
> patched" ]] ; then
> +if [[ "$(cat /proc/cmdline)" !=3D "$MOD_LIVEPATCH1: this has been live
> patched" ]] ; then
> =C2=A0	echo -e "FAIL\n\n"
> =C2=A0	die "livepatch kselftest(s) failed"
> =C2=A0fi
> =C2=A0
> -disable_lp $MOD_LIVEPATCH
> -unload_lp $MOD_LIVEPATCH
> +disable_lp $MOD_LIVEPATCH1
> +unload_lp $MOD_LIVEPATCH1
> =C2=A0
> -if [[ "$(cat /proc/cmdline)" =3D=3D "$MOD_LIVEPATCH: this has been live
> patched" ]] ; then
> +if [[ "$(cat /proc/cmdline)" =3D=3D "$MOD_LIVEPATCH1: this has been live
> patched" ]] ; then
> =C2=A0	echo -e "FAIL\n\n"
> =C2=A0	die "livepatch kselftest(s) failed"
> =C2=A0fi
> =C2=A0
> -check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
> -livepatch: enabling patch '$MOD_LIVEPATCH'
> -livepatch: '$MOD_LIVEPATCH': initializing patching transition
> -livepatch: '$MOD_LIVEPATCH': starting patching transition
> -livepatch: '$MOD_LIVEPATCH': completing patching transition
> -livepatch: '$MOD_LIVEPATCH': patching complete
> -% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
> -livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
> -livepatch: '$MOD_LIVEPATCH': starting unpatching transition
> -livepatch: '$MOD_LIVEPATCH': completing unpatching transition
> -livepatch: '$MOD_LIVEPATCH': unpatching complete
> -% rmmod $MOD_LIVEPATCH"
> +check_result "% insmod test_modules/$MOD_LIVEPATCH1.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH1'
> +livepatch: '$MOD_LIVEPATCH1': initializing patching transition
> +livepatch: '$MOD_LIVEPATCH1': starting patching transition
> +livepatch: '$MOD_LIVEPATCH1': completing patching transition
> +livepatch: '$MOD_LIVEPATCH1': patching complete
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH1/enabled
> +livepatch: '$MOD_LIVEPATCH1': initializing unpatching transition
> +livepatch: '$MOD_LIVEPATCH1': starting unpatching transition
> +livepatch: '$MOD_LIVEPATCH1': completing unpatching transition
> +livepatch: '$MOD_LIVEPATCH1': unpatching complete
> +% rmmod $MOD_LIVEPATCH1"
> =C2=A0
> =C2=A0
> =C2=A0# - load a livepatch that modifies the output from /proc/cmdline an=
d
> @@ -53,7 +55,7 @@ livepatch: '$MOD_LIVEPATCH': unpatching complete
> =C2=A0
> =C2=A0start_test "multiple livepatches"
> =C2=A0
> -load_lp $MOD_LIVEPATCH
> +load_lp $MOD_LIVEPATCH1
> =C2=A0
> =C2=A0grep 'live patched' /proc/cmdline > /dev/kmsg
> =C2=A0grep 'live patched' /proc/meminfo > /dev/kmsg
> @@ -69,26 +71,26 @@ unload_lp $MOD_REPLACE
> =C2=A0grep 'live patched' /proc/cmdline > /dev/kmsg
> =C2=A0grep 'live patched' /proc/meminfo > /dev/kmsg
> =C2=A0
> -disable_lp $MOD_LIVEPATCH
> -unload_lp $MOD_LIVEPATCH
> +disable_lp $MOD_LIVEPATCH1
> +unload_lp $MOD_LIVEPATCH1
> =C2=A0
> =C2=A0grep 'live patched' /proc/cmdline > /dev/kmsg
> =C2=A0grep 'live patched' /proc/meminfo > /dev/kmsg
> =C2=A0
> -check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
> -livepatch: enabling patch '$MOD_LIVEPATCH'
> -livepatch: '$MOD_LIVEPATCH': initializing patching transition
> -livepatch: '$MOD_LIVEPATCH': starting patching transition
> -livepatch: '$MOD_LIVEPATCH': completing patching transition
> -livepatch: '$MOD_LIVEPATCH': patching complete
> -$MOD_LIVEPATCH: this has been live patched
> +check_result "% insmod test_modules/$MOD_LIVEPATCH1.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH1'
> +livepatch: '$MOD_LIVEPATCH1': initializing patching transition
> +livepatch: '$MOD_LIVEPATCH1': starting patching transition
> +livepatch: '$MOD_LIVEPATCH1': completing patching transition
> +livepatch: '$MOD_LIVEPATCH1': patching complete
> +$MOD_LIVEPATCH1: this has been live patched
> =C2=A0% insmod test_modules/$MOD_REPLACE.ko replace=3D0
> =C2=A0livepatch: enabling patch '$MOD_REPLACE'
> =C2=A0livepatch: '$MOD_REPLACE': initializing patching transition
> =C2=A0livepatch: '$MOD_REPLACE': starting patching transition
> =C2=A0livepatch: '$MOD_REPLACE': completing patching transition
> =C2=A0livepatch: '$MOD_REPLACE': patching complete
> -$MOD_LIVEPATCH: this has been live patched
> +$MOD_LIVEPATCH1: this has been live patched
> =C2=A0$MOD_REPLACE: this has been live patched
> =C2=A0% echo 0 > /sys/kernel/livepatch/$MOD_REPLACE/enabled
> =C2=A0livepatch: '$MOD_REPLACE': initializing unpatching transition
> @@ -96,35 +98,57 @@ livepatch: '$MOD_REPLACE': starting unpatching
> transition
> =C2=A0livepatch: '$MOD_REPLACE': completing unpatching transition
> =C2=A0livepatch: '$MOD_REPLACE': unpatching complete
> =C2=A0% rmmod $MOD_REPLACE
> -$MOD_LIVEPATCH: this has been live patched
> -% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
> -livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
> -livepatch: '$MOD_LIVEPATCH': starting unpatching transition
> -livepatch: '$MOD_LIVEPATCH': completing unpatching transition
> -livepatch: '$MOD_LIVEPATCH': unpatching complete
> -% rmmod $MOD_LIVEPATCH"
> +$MOD_LIVEPATCH1: this has been live patched
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH1/enabled
> +livepatch: '$MOD_LIVEPATCH1': initializing unpatching transition
> +livepatch: '$MOD_LIVEPATCH1': starting unpatching transition
> +livepatch: '$MOD_LIVEPATCH1': completing unpatching transition
> +livepatch: '$MOD_LIVEPATCH1': unpatching complete
> +% rmmod $MOD_LIVEPATCH1"
> =C2=A0
> =C2=A0
> =C2=A0# - load a livepatch that modifies the output from /proc/cmdline an=
d
> =C2=A0#=C2=A0=C2=A0 verify correct behavior
> -# - load an atomic replace livepatch and verify that only the second
> is active
> -# - remove the first livepatch and verify that the atomic replace
> livepatch
> -#=C2=A0=C2=A0 is still active
> +# - load two addtional livepatches and check the number of livepatch
> modules
> +#=C2=A0=C2=A0 applied
> +# - load an atomic replace livepatch and check that the other three
> modules were
> +#=C2=A0=C2=A0 disabled
> +# - remove all livepatches besides the atomic replace one and verify
> that the
> +#=C2=A0=C2=A0 atomic replace livepatch is still active
> =C2=A0# - remove the atomic replace livepatch and verify that none are
> active
> =C2=A0
> =C2=A0start_test "atomic replace livepatch"
> =C2=A0
> -load_lp $MOD_LIVEPATCH
> +load_lp $MOD_LIVEPATCH1
> =C2=A0
> =C2=A0grep 'live patched' /proc/cmdline > /dev/kmsg
> =C2=A0grep 'live patched' /proc/meminfo > /dev/kmsg
> =C2=A0
> +for mod in $MOD_LIVEPATCH2 $MOD_LIVEPATCH3; do
> +	load_lp "$mod"
> +done
> +
> +mods=3D(/sys/kernel/livepatch/*)
> +nmods=3D${#mods[@]}
> +if [ "$nmods" -ne 3 ]; then
> +	die "Expecting three modules listed, found $nmods"
> +fi
> +
> =C2=A0load_lp $MOD_REPLACE replace=3D1
> =C2=A0
> =C2=A0grep 'live patched' /proc/cmdline > /dev/kmsg
> =C2=A0grep 'live patched' /proc/meminfo > /dev/kmsg
> =C2=A0
> -unload_lp $MOD_LIVEPATCH
> +mods=3D(/sys/kernel/livepatch/*)
> +nmods=3D${#mods[@]}
> +if [ "$nmods" -ne 1 ]; then
> +	die "Expecting only one moduled listed, found $nmods"
> +fi
> +
> +# These modules were disabled by the atomic replace
> +for mod in $MOD_LIVEPATCH3 $MOD_LIVEPATCH2 $MOD_LIVEPATCH1; do
> +	unload_lp "$mod"
> +done
> =C2=A0
> =C2=A0grep 'live patched' /proc/cmdline > /dev/kmsg
> =C2=A0grep 'live patched' /proc/meminfo > /dev/kmsg
> @@ -135,13 +159,27 @@ unload_lp $MOD_REPLACE
> =C2=A0grep 'live patched' /proc/cmdline > /dev/kmsg
> =C2=A0grep 'live patched' /proc/meminfo > /dev/kmsg
> =C2=A0
> -check_result "% insmod test_modules/$MOD_LIVEPATCH.ko
> -livepatch: enabling patch '$MOD_LIVEPATCH'
> -livepatch: '$MOD_LIVEPATCH': initializing patching transition
> -livepatch: '$MOD_LIVEPATCH': starting patching transition
> -livepatch: '$MOD_LIVEPATCH': completing patching transition
> -livepatch: '$MOD_LIVEPATCH': patching complete
> -$MOD_LIVEPATCH: this has been live patched
> +check_result "% insmod test_modules/$MOD_LIVEPATCH1.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH1'
> +livepatch: '$MOD_LIVEPATCH1': initializing patching transition
> +livepatch: '$MOD_LIVEPATCH1': starting patching transition
> +livepatch: '$MOD_LIVEPATCH1': completing patching transition
> +livepatch: '$MOD_LIVEPATCH1': patching complete
> +$MOD_LIVEPATCH1: this has been live patched
> +% insmod test_modules/$MOD_LIVEPATCH2.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH2'
> +livepatch: '$MOD_LIVEPATCH2': initializing patching transition
> +livepatch: '$MOD_LIVEPATCH2': starting patching transition
> +livepatch: '$MOD_LIVEPATCH2': completing patching transition
> +livepatch: '$MOD_LIVEPATCH2': patching complete
> +% insmod test_modules/$MOD_LIVEPATCH3.ko
> +livepatch: enabling patch '$MOD_LIVEPATCH3'
> +livepatch: '$MOD_LIVEPATCH3': initializing patching transition
> +$MOD_LIVEPATCH3: pre_patch_callback: vmlinux
> +livepatch: '$MOD_LIVEPATCH3': starting patching transition
> +livepatch: '$MOD_LIVEPATCH3': completing patching transition
> +$MOD_LIVEPATCH3: post_patch_callback: vmlinux
> +livepatch: '$MOD_LIVEPATCH3': patching complete
> =C2=A0% insmod test_modules/$MOD_REPLACE.ko replace=3D1
> =C2=A0livepatch: enabling patch '$MOD_REPLACE'
> =C2=A0livepatch: '$MOD_REPLACE': initializing patching transition
> @@ -149,7 +187,9 @@ livepatch: '$MOD_REPLACE': starting patching
> transition
> =C2=A0livepatch: '$MOD_REPLACE': completing patching transition
> =C2=A0livepatch: '$MOD_REPLACE': patching complete
> =C2=A0$MOD_REPLACE: this has been live patched
> -% rmmod $MOD_LIVEPATCH
> +% rmmod $MOD_LIVEPATCH3
> +% rmmod $MOD_LIVEPATCH2
> +% rmmod $MOD_LIVEPATCH1
> =C2=A0$MOD_REPLACE: this has been live patched
> =C2=A0% echo 0 > /sys/kernel/livepatch/$MOD_REPLACE/enabled
> =C2=A0livepatch: '$MOD_REPLACE': initializing unpatching transition
>=20
> ---
> base-commit: 6d69b6c12fce479fde7bc06f686212451688a102
> change-id: 20240525-lp-atomic-replace-90b33ed018dc
>=20
> Best regards,


