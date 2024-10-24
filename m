Return-Path: <live-patching+bounces-760-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 070C19ADF10
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2024 10:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8A19AB210AD
	for <lists+live-patching@lfdr.de>; Thu, 24 Oct 2024 08:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18781149013;
	Thu, 24 Oct 2024 08:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bDEND6vA"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D061AB522;
	Thu, 24 Oct 2024 08:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729758249; cv=none; b=YJD9VJVEbET4/FEs/SANaLRNGRpBBwKAoOk56cBD58rTn9zVZatvr6/xarEfiG4zYBMnzPlgnmNvTeRYVQpTckd6iMNY00trrf/X5Et3NppxsTxq/qPY+5ccHpg2PGfLv2aq12fvDwZQxc+HhC/SSww6ZScqs7iVYpwqHlvyVsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729758249; c=relaxed/simple;
	bh=xJzaFngehew0ROGk8JU9U5XSHTCrxFB9RwRYMWIqsj4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Vc+w0i+jq2wJJDrR1U0WzHN5JkgsMv8q2RIkThyRpiclIo4KJO8Y1y/CufLASrj5WvAoCW10DZSAxd+6HKzWqne0vYerNSWeQ/lKWODXv2ewhd9z9O6RCdldq5J/zRmOYQv3qZ/47PqEUOl1ryp/q3Qllizc9FZgq6iI46mEoMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bDEND6vA; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7db908c9c83so329529a12.2;
        Thu, 24 Oct 2024 01:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729758246; x=1730363046; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XQNtHPYi7IDVmIRJ5gs3p3G0OUGntsTWUVM054sbtbA=;
        b=bDEND6vALCkE46f/SoSnwOeKrjmKION8ot5da/Vw1ChMkdqS8umWGtMkmUpqsL44qV
         VludpRS55TuiIQHTiZUy71S1HEyI0G+S3r0cJkIEhX6gWa/SJjtPB7HJPhFnOOM23iN4
         wrT7mCNan72jJVBJGQXRLC0uLcIT+VEUl4gRGjtyT4oB6cZfqL2u6o4RdggPfX+xf4QR
         mFbnrDKpJYU1v4BlDFQ99YKpYZ8WJAkwz9CPDqbJRkX6pBqDAyELl2Dj1hlzcHFjN09t
         0lqjsmSDFABLfpXOz2w0nKZxd+bfeNbHKkbDwkpkaWwTf5cjrkVRRBNg+S9OIcwny52W
         J6AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729758246; x=1730363046;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQNtHPYi7IDVmIRJ5gs3p3G0OUGntsTWUVM054sbtbA=;
        b=XN2CroYviEst7JNSgaNkDFgthFY3QkOINdQ7TQWjOHP9wYkIf7bCtWsAnzKtcflVsx
         YXhMvkkkYofUMylH3gAp4cKbUPj8jUSEERL2woUP1hG1T648O15nudd5kkFhIbs5V5ys
         QcWBgWqb/fsMGxhivgC4XSSF78nKgo5sxLTnbzEuB4WQLsFH2kw4fYrfgnuY8txy6Ybx
         rRzmFkH6X6f0nPatjGiY/TlWWYp2p6RCmhA2ssXBy/AiPliuweZPpIdZjc0NAaZRjoy2
         +v5FHN1q45G+67I+eIrG8KBP0iiXRZXWcYIZJHv9odgENqwyoefBwCWxCFc3v33LwZ6B
         Lt2g==
X-Forwarded-Encrypted: i=1; AJvYcCU8BDiEROOipvvsftT3Xvw5ZqnV1rarQw2tBLZE3xVgEhUKhwveST7m1WJZyXLz3qCUzEeluqlqS+LIqkH5wA==@vger.kernel.org, AJvYcCWYzalwoLFrcG1fAjZH1G+xT4ImcyybEvI8tlZSH1+X+ResaugTTjSfK7KsHe/n7Cd+jN+pkLTjfq7SnF0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe2bjE6I1b3QM71du/I9Uh9tsnwH7B6ZGeAVhV7/O0sVVJlAD5
	tB5MG2j0uaif5Lr21m4hKzVi84E2itxzlE3NWOESWx8wB6hCw8rv
X-Google-Smtp-Source: AGHT+IEpijEwb8s8p9DJc0Ib0aDLS6oX4qyUkr0Iviiih/JOW64EusPfuddR/duiGTOcHk10IQp9KQ==
X-Received: by 2002:a05:6a21:3a84:b0:1d7:cc6:53d0 with SMTP id adf61e73a8af0-1d978ad5a5amr6641489637.5.1729758246231;
        Thu, 24 Oct 2024 01:24:06 -0700 (PDT)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeab583d9sm8104437a12.49.2024.10.24.01.24.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2024 01:24:05 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH V2] selftests: livepatch: add test cases of stack_order
 sysfs interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <ZxoDZhpEX_M-vuRP@pathway.suse.cz>
Date: Thu, 24 Oct 2024 16:23:51 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <09DE904A-5DAE-40C0-9F03-A96D0F80E1D4@gmail.com>
References: <20241024044317.46666-1-zhangwarden@gmail.com>
 <20241024044317.46666-2-zhangwarden@gmail.com>
 <ZxoDZhpEX_M-vuRP@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Oct 24, 2024, at 16:20, Petr Mladek <pmladek@suse.com> wrote:
>=20
> On Thu 2024-10-24 12:43:17, Wardenjohn wrote:
>> Add selftest test cases to sysfs attribute 'stack_order'.
>>=20
>> Suggested-by: Petr Mladek <pmladek@suse.com>
>> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
>> ---
>> .../testing/selftests/livepatch/test-sysfs.sh | 71 =
+++++++++++++++++++
>> 1 file changed, 71 insertions(+)
>>=20
>> diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh =
b/tools/testing/selftests/livepatch/test-sysfs.sh
>> index 05a14f5a7bfb..718027cc3aba 100755
>> --- a/tools/testing/selftests/livepatch/test-sysfs.sh
>> +++ b/tools/testing/selftests/livepatch/test-sysfs.sh
>> @@ -5,6 +5,8 @@
>> . $(dirname $0)/functions.sh
>>=20
>> MOD_LIVEPATCH=3Dtest_klp_livepatch
>> +MOD_LIVEPATCH2=3Dtest_klp_callbacks_demo
>> +MOD_LIVEPATCH3=3Dtest_klp_syscall
>>=20
>> setup_config
>>=20
>> @@ -21,6 +23,8 @@ check_sysfs_rights "$MOD_LIVEPATCH" "force" =
"--w-------"
>> check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
>=20
> Sigh, you moved it from some reason. My proposed diff added
> "stack_order" here between "replace" and "transition" to follow
> the alphabetical order.
>=20
>> check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
>> check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
>> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
>> +check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
>> check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
>> check_sysfs_value  "$MOD_LIVEPATCH" "vmlinux/patched" "1"
>=20
> After fixing the alphabetical order:
>=20
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Tested-by: Petr Mladek <pmladek@suse.com>
>=20
> I could fix the ordering when pushing the patch.
>=20
> Best Regards,
> Petr

OK, I use this order just according to the order added to this=20
test case. Didn't consider the alphabetical order.

If necessary, I can resent a V3 patch.

Best Regards.
Wardenjohn.



