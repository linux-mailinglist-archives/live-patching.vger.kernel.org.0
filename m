Return-Path: <live-patching+bounces-69-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A0180553C
	for <lists+live-patching@lfdr.de>; Tue,  5 Dec 2023 13:53:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 584EB1C20BED
	for <lists+live-patching@lfdr.de>; Tue,  5 Dec 2023 12:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC38F54756;
	Tue,  5 Dec 2023 12:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RkrrZy4e"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2432C181
	for <live-patching@vger.kernel.org>; Tue,  5 Dec 2023 04:52:55 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2ca0f21e48cso17992901fa.2
        for <live-patching@vger.kernel.org>; Tue, 05 Dec 2023 04:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1701780773; x=1702385573; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/6khWfPZUJLhn3k3Km8qMBNnWS1yZtR1UUMcUgVXgbE=;
        b=RkrrZy4eHDBcJhQOuMWlKJgQkGX8wyiPArC4re/LHLGQAQGIB3z/ag2tdSHQG0GqqP
         PLALcv5E3RCU7jC61zirPrbfbUeU8trpx1HXpU8Ub4gknVdlumt3XX28AO0ZbV0zwqSa
         tmae09CRYKt+dH1alWiua3dmCCxit4f8ZPP0IggTTeQNnDWo52WGMqpvBN+NXODCVYn5
         qojEA03dAA+/RvvgaxhROBfQe/ptbZjvz2H7Hs6pe9vvjz7h7EvBnLYp9V4w5KZb/qRy
         sN/EK3qu6jnRtsWuaxsW34HX3LWgFnt+Ndz/LJ+uZA8s5ge5w3DzNTZR1pc+3nhRIwTx
         V0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701780773; x=1702385573;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/6khWfPZUJLhn3k3Km8qMBNnWS1yZtR1UUMcUgVXgbE=;
        b=q9kNVmxf6NhsulDUG1sMtcK06yfTNN7oNChfAhblTaUq8VuS9OD6lE0NPehjHmG7jm
         1ZzV6+/6FBNFqc9lOh6hTRrUQeBgj09iatt37Umo9O3xANyCWfUTnja13OcwWCCv/KXp
         qJfpBQrDVwHg43pcUuMELExUPR3w60vXL1hdW6SkMKRFETJrkCjAnWoq7FQ/wbJTYm8d
         7PUvbamcmXxAEZzW+eObwEpcafWgX3/ITCWbY7tGFfaMfrGNN9vTHTiQJnug7K+vQ1yf
         BPn9wduENJQ7Bqp293OxYUlEBdP5zizN9WxH3qHjtkIAxapGUspkExVyMhKiUDQ7DsjB
         RMBQ==
X-Gm-Message-State: AOJu0Yw5XU4RbRWfGAaQo5jMUyS1KTWtGsHoBFaMcQd4fQ+pwPaA02Km
	efO6+nmQhFYZEngHN6LW70hNAg==
X-Google-Smtp-Source: AGHT+IEaTv9JPYFtY5cztOH3hevOJnMBWMWWpGD6f//fYLRlQTcv4U9qGajlw8lAyC7RdC8q8wP2zQ==
X-Received: by 2002:a05:651c:cc:b0:2c9:f0e8:bb5f with SMTP id 12-20020a05651c00cc00b002c9f0e8bb5fmr2841059ljr.40.1701780773336;
        Tue, 05 Dec 2023 04:52:53 -0800 (PST)
Received: from ?IPv6:2804:30c:915:cb00:89a8:6d94:ec55:e0a3? ([2804:30c:915:cb00:89a8:6d94:ec55:e0a3])
        by smtp.gmail.com with ESMTPSA id e8-20020a17090ab38800b002801ca4fad2sm4479134pjr.10.2023.12.05.04.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 04:52:52 -0800 (PST)
Message-ID: <12a9ec1bc84dc6d4b461e5c780ba7d3c3aa91740.camel@suse.com>
Subject: Re: [PATCH v3 3/3] selftests: livepatch: Test livepatching a
 heavily called syscall
From: mpdesouza@suse.com
To: Shuah Khan <skhan@linuxfoundation.org>, Marcos Paulo de Souza
	 <mpdesouza@suse.de>
Cc: Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander
 Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>,  Sven Schnelle <svens@linux.ibm.com>, Josh
 Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,  Miroslav
 Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Joe Lawrence
 <joe.lawrence@redhat.com>, linux-kselftest@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-s390@vger.kernel.org, live-patching@vger.kernel.org
Date: Tue, 05 Dec 2023 09:52:46 -0300
In-Reply-To: <8b95b96c-6aeb-4bf0-8ee9-2ba62330c672@linuxfoundation.org>
References: <20231031-send-lp-kselftests-v3-0-2b1655c2605f@suse.com>
	 <20231031-send-lp-kselftests-v3-3-2b1655c2605f@suse.com>
	 <f9d82fa6-08d7-4ab6-badc-691987b37a82@linuxfoundation.org>
	 <unpg4z7eig6qbudgulnr6sog65fq7s2dy4u2vp2dgkdrq5csdw@dltnxuw6kw5b>
	 <8b95b96c-6aeb-4bf0-8ee9-2ba62330c672@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2023-12-01 at 16:38 +0000, Shuah Khan wrote:
> On 12/1/23 06:13, Marcos Paulo de Souza wrote:
> > On Thu, Nov 30, 2023 at 04:24:26PM -0700, Shuah Khan wrote:
>=20
> > >=20
> > > Missing module name? Is there a reason to not name this module?
> >=20
> > Can you please elaborate? This new module use the same MODULE_
> > macros used by
> > the current livepatch selftests. What do you mean by module name?
> >=20
>=20
> Pre-commit checpatch script spdx check complained about the module
> name.
> Please run it to see the message.

I've ran checkpatch on all the tree patches, and so far it complained
about MAINTANERS file needing to be updated (since we removed
lib/livepatch and it's mentioned on MAINTAINERS file):

$ ./scripts/checkpatch.pl 000*.patch                   =20
-----------------------------------------------------------
0001-kselftests-lib.mk-Add-TEST_GEN_MODS_DIR-variable.patch
-----------------------------------------------------------
total: 0 errors, 0 warnings, 68 lines checked

0001-kselftests-lib.mk-Add-TEST_GEN_MODS_DIR-variable.patch has no
obvious style problems and is ready for submission.
---------------------------------------------------------------
0002-livepatch-Move-tests-from-lib-livepatch-to-selftests.patch
---------------------------------------------------------------
WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit
description?)
#17:=20
debug and rebuild the tests by running make on the selftests/livepatch
directory,

WARNING: added, moved or deleted file(s), does MAINTAINERS need
updating?
#82:=20
 rename {lib/livepatch =3D>
tools/testing/selftests/livepatch/test_modules}/test_klp_atomic_replace
.c (100%)

total: 0 errors, 2 warnings, 519 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-
inplace.

0002-livepatch-Move-tests-from-lib-livepatch-to-selftests.patch has
style problems, please review.
---------------------------------------------------------------
0003-selftests-livepatch-Test-livepatching-a-heavily-call.patch
---------------------------------------------------------------
WARNING: added, moved or deleted file(s), does MAINTAINERS need
updating?
#60:=20
new file mode 100755

total: 0 errors, 1 warnings, 237 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-
inplace.

0003-selftests-livepatch-Test-livepatching-a-heavily-call.patch has
style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

I couldn't find any mention about "missing module name". Is your script
showing more warnings than these ones? Can you please share your
output?

I'll fix MAINTAINERS file but I'll wait until I understand what's
missing in your checkpatch script to resend the patchset.

Thanks,
  Marcos=20

>=20
> thanks,
> -- Shuah
>=20


