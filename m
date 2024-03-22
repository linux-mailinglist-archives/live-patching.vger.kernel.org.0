Return-Path: <live-patching+bounces-202-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DE2988742A
	for <lists+live-patching@lfdr.de>; Fri, 22 Mar 2024 21:31:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA1BFB223C7
	for <lists+live-patching@lfdr.de>; Fri, 22 Mar 2024 20:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E4C7866E;
	Fri, 22 Mar 2024 20:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f9ShoMH8"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15B353361
	for <live-patching@vger.kernel.org>; Fri, 22 Mar 2024 20:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711139508; cv=none; b=i7I5ID6H6AYTwX9Uli4bUcx6t9p2iqw/1Z70Ma6NlDsw79SlrMP3kq5obN41gPhSJ6klYpb7nJeRBitKcH3PDXq9CzhMMPePjqBe2v2vv+ZUk+SgUIe0YsmTnCfVdeCHhJbYKVpJQ9CFCcoudPM/bIesBpTso4h/NE58LHAsOjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711139508; c=relaxed/simple;
	bh=3On0zwm6jM778YElkqeztalhlg0rp2vBVWWMjQCoI1M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SEjXLUjAYZDxdWrqRPfi/FL2rFFECJynRVa6VwwKpm4JPKZJSfdPPUQZbsqjgLBRmdOwcO6IJk56t8B4XDbGuT1WDb4F3GonyUq04xBuanQv6IfgqDtLYSv0yB0PGpA/zR8LWAqPbIGcfeN7UPJx82/hVff9OKVos3wb/9oq/V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f9ShoMH8; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a46ba938de0so355724966b.3
        for <live-patching@vger.kernel.org>; Fri, 22 Mar 2024 13:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711139504; x=1711744304; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bkEtvYqy1WvJcxiq2A/RIrn4954G/qQAXJYaM8Oh1Rc=;
        b=f9ShoMH8457G/V9DH6KtgyRoF8sIeWN+T9+R+0ajoU5RslU5A3Bw5yoFIGnBJge9cH
         QxtYL0N4+xoqQEPDj86x9xPesfm+H0Bm1Qm8z6TGm2HX+5u2u/9UcgQmKpdyrPxe6PX5
         dzC1nchDNB9+4HjPMIUgrkd1uIggT/kDppPVvx3oSVfSpyDq2RhFM7s82iekByEQDeXl
         g00RrpigiXAIGpelyL2mH5MdWazLUDcH67vNHT+uj/Ux2AqeQsnHVFpZ4hKThcHdm951
         nwOOidMMUhokuXsDLr6nPnwIv6EKs288MIj5pQ3nG5V9Ea5MtgwJeoBNeqTN2l+REvQ5
         Ik8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711139504; x=1711744304;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bkEtvYqy1WvJcxiq2A/RIrn4954G/qQAXJYaM8Oh1Rc=;
        b=gfTCmQAqsl/D1M+k5DiuBD+cwjnxGwHWXV7atqHf1EGxd6uiPLWBIY0y/6uhy97Mge
         bdeq9GrJbee32bYLIW6efaJ76Jj2WYdpwqC9W82p42CEs5AwQwLH9O+sn4fA9DMGos7X
         Z8kIXmDm2B474nGXWWJWgJtIDsw7frd1PWXIOTlQu5L1YCXyvMRt2OUsb9NtSBSS08aL
         3WnRKHVw24a656kiltQfoYorfmbGNlUpDUjhHrNooS2t17DZL9yAqE+Av9UL8fwxUVAD
         KkZUrSOBiLqnk6GfFkvxP+LrVT36T03CT0Jizlf+Z/38QuGPNfi4qaKhqgIK5Iv6S+g8
         mdCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqE51gj3cp4jNpwkGV//VDBkflsQpVf5+Iu0LU3KeYxFpvYI20KILR3j7A+/59ib5ystJrz2a09jOIsyMtXSoZsGa6nvrLDTmKh3DG6g==
X-Gm-Message-State: AOJu0YzGxcpdhPg5E51MNn79d558ciVMC3zrpoCdFJ2xImEwVGUMW5Ju
	vne8TpXLw39slafhwWhrrj+ia2OMEgwo4U/ibXwUNj4Mmol1Egh0KuoLyB5WanY=
X-Google-Smtp-Source: AGHT+IE9CDoW3UpB5yWwdMtatijavNSDtDLQOJ31diqG3OtVOLCRXzNT+3xAKMg/PDwf8hgs+atsrw==
X-Received: by 2002:a17:906:c12:b0:a47:32f7:fe9e with SMTP id s18-20020a1709060c1200b00a4732f7fe9emr528540ejf.37.1711139503934;
        Fri, 22 Mar 2024 13:31:43 -0700 (PDT)
Received: from ?IPv6:2804:5078:98c:e700:58f2:fc97:371f:2? ([2804:5078:98c:e700:58f2:fc97:371f:2])
        by smtp.gmail.com with ESMTPSA id lr22-20020a170906fb9600b00a46fc33b479sm191492ejb.13.2024.03.22.13.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 13:31:43 -0700 (PDT)
Message-ID: <9d4c5c6bd5b7fd0305f9ec26038f4afbea5fc166.camel@suse.com>
Subject: Re: [PATCH] selftests: livepatch: Test atomic replace against
 multiple modules
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Joe Lawrence <joe.lawrence@redhat.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>,  Jiri Kosina <jikos@kernel.org>, Miroslav Benes
 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Shuah Khan
 <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Date: Fri, 22 Mar 2024 17:31:35 -0300
In-Reply-To: <56bf6323-9e9b-a0e3-f505-d628aac793d4@redhat.com>
References: <20240312-lp-selftest-new-test-v1-1-9c843e25e38e@suse.com>
	 <56bf6323-9e9b-a0e3-f505-d628aac793d4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-03-21 at 10:08 -0400, Joe Lawrence wrote:
> On 3/12/24 08:12, Marcos Paulo de Souza wrote:
> > This new test checks if a livepatch with replace attribute set
> > replaces
> > all previously applied livepatches.
> >=20
> > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > ---
> > =C2=A0tools/testing/selftests/livepatch/Makefile=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +-
> > =C2=A0.../selftests/livepatch/test-atomic-replace.sh=C2=A0=C2=A0=C2=A0=
=C2=A0 | 71
> > ++++++++++++++++++++++
> > =C2=A02 files changed, 73 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/tools/testing/selftests/livepatch/Makefile
> > b/tools/testing/selftests/livepatch/Makefile
> > index 35418a4790be..e92f61208d35 100644
> > --- a/tools/testing/selftests/livepatch/Makefile
> > +++ b/tools/testing/selftests/livepatch/Makefile
> > @@ -10,7 +10,8 @@ TEST_PROGS :=3D \
> > =C2=A0	test-state.sh \
> > =C2=A0	test-ftrace.sh \
> > =C2=A0	test-sysfs.sh \
> > -	test-syscall.sh
> > +	test-syscall.sh \
> > +	test-atomic-replace.sh
> > =C2=A0
> > =C2=A0TEST_FILES :=3D settings
> > =C2=A0
> > diff --git a/tools/testing/selftests/livepatch/test-atomic-
> > replace.sh b/tools/testing/selftests/livepatch/test-atomic-
> > replace.sh
> > new file mode 100755
> > index 000000000000..09a3dcdcb8de
> > --- /dev/null
> > +++ b/tools/testing/selftests/livepatch/test-atomic-replace.sh
> > @@ -0,0 +1,71 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Copyright (C) 2024 SUSE
> > +# Author: Marcos Paulo de Souza <mpdesouza@suse.com>
> > +
> > +. $(dirname $0)/functions.sh
> > +
> > +MOD_REPLACE=3Dtest_klp_atomic_replace
> > +
> > +setup_config
> > +
> > +# - Load three livepatch modules.
> > +# - Load one more livepatch with replace being set, and check that
> > only one
> > +#=C2=A0=C2=A0 livepatch module is being listed.
> > +
> > +start_test "apply one liveptach to replace multiple livepatches"
> > +
> > +for mod in test_klp_livepatch test_klp_syscall
> > test_klp_callbacks_demo; do
> > +	load_lp $mod
> > +done
> > +
> > +nmods=3D$(ls /sys/kernel/livepatch | wc -l)
> > +if [ $nmods -ne 3 ]; then
> > +	die "Expecting three modules listed, found $nmods"
> > +fi
> > +
> > +load_lp $MOD_REPLACE replace=3D1
> > +
> > +nmods=3D$(ls /sys/kernel/livepatch | wc -l)
> > +if [ $nmods -ne 1 ]; then
> > +	die "Expecting only one moduled listed, found $nmods"
> > +fi
> > +
> > +disable_lp $MOD_REPLACE
> > +unload_lp $MOD_REPLACE
> > +
> > +check_result "% insmod test_modules/test_klp_livepatch.ko
> > +livepatch: enabling patch 'test_klp_livepatch'
> > +livepatch: 'test_klp_livepatch': initializing patching transition
> > +livepatch: 'test_klp_livepatch': starting patching transition
> > +livepatch: 'test_klp_livepatch': completing patching transition
> > +livepatch: 'test_klp_livepatch': patching complete
> > +% insmod test_modules/test_klp_syscall.ko
> > +livepatch: enabling patch 'test_klp_syscall'
> > +livepatch: 'test_klp_syscall': initializing patching transition
> > +livepatch: 'test_klp_syscall': starting patching transition
> > +livepatch: 'test_klp_syscall': completing patching transition
> > +livepatch: 'test_klp_syscall': patching complete
> > +% insmod test_modules/test_klp_callbacks_demo.ko
> > +livepatch: enabling patch 'test_klp_callbacks_demo'
> > +livepatch: 'test_klp_callbacks_demo': initializing patching
> > transition
> > +test_klp_callbacks_demo: pre_patch_callback: vmlinux
> > +livepatch: 'test_klp_callbacks_demo': starting patching transition
> > +livepatch: 'test_klp_callbacks_demo': completing patching
> > transition
> > +test_klp_callbacks_demo: post_patch_callback: vmlinux
> > +livepatch: 'test_klp_callbacks_demo': patching complete
> > +% insmod test_modules/test_klp_atomic_replace.ko replace=3D1
> > +livepatch: enabling patch 'test_klp_atomic_replace'
> > +livepatch: 'test_klp_atomic_replace': initializing patching
> > transition
> > +livepatch: 'test_klp_atomic_replace': starting patching transition
> > +livepatch: 'test_klp_atomic_replace': completing patching
> > transition
> > +livepatch: 'test_klp_atomic_replace': patching complete
> > +% echo 0 > /sys/kernel/livepatch/test_klp_atomic_replace/enabled
> > +livepatch: 'test_klp_atomic_replace': initializing unpatching
> > transition
> > +livepatch: 'test_klp_atomic_replace': starting unpatching
> > transition
> > +livepatch: 'test_klp_atomic_replace': completing unpatching
> > transition
> > +livepatch: 'test_klp_atomic_replace': unpatching complete
> > +% rmmod test_klp_atomic_replace"
> > +
> > +exit 0
> >=20
>=20
> Hi Marcos,
>=20
> I'm not against adding a specific atomic replace test, but for a
> quick
> tl/dr what is the difference between this new test and
> test-livepatch.sh's "atomic replace livepatch" test?
>=20
> If this one provides better coverage, should we follow up with
> removing
> the existing one?

Hi Joe,

thanks for looking at it. To be honest I haven't checked the current
use of atomic replace on test-livepatch.sh =3D/

yes, that's mostly the same case, but in mine I load three modules and
then load the third one replacing the others, while in the test-
livepatch.sh we have only one module that is loaded, replaced, and then
we unload the replaced one.

Do you see value in extending the test at test-livepatch.sh to load
more than one LP moduled and the replace all of them with another one?
I believe that it adds more coverage, while keeping the number of tests
the same.

Thanks!

>=20


