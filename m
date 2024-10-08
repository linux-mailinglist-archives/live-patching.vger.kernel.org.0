Return-Path: <live-patching+bounces-723-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D936993C82
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 03:51:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50C011F24A95
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 01:51:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4109618651;
	Tue,  8 Oct 2024 01:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hdZ01VkP"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C555725776;
	Tue,  8 Oct 2024 01:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352301; cv=none; b=WoMsxJ836o7IrxTg0mpgCoXKWaX0VEXhG33kxg5+78S1rabu1e4K/XjxOAULhNONObXYK/IsKjDyvRhfRlg/EttWwEROlQlm4M4wYJT5ix6LXlSP6UZrh5/ms67eFTsATXHozjNSC2CLviEbxv6Do2k+kMg+OTRFqUf3qDNyHaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352301; c=relaxed/simple;
	bh=KUcfKhY1OuJjjtPFVm5auF2wbUcjl7/PSnpHOJHFgMw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=UuI5TRK69/FkZnyifRnieRmNs73YeFPRMPE4qo7ACukGvZuE5UNI54Fo6o/glg9PEBKiqNxUmq35x0Ld01vbt8tDbTYV74YP9h2WnIM8dPIWKPtXYcFqB0Vi4itW4t2zbhKYCMPTdvi/hpgO1S//YPaj++NaB7AoLPcC9TAyMjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hdZ01VkP; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20b86298710so42801285ad.1;
        Mon, 07 Oct 2024 18:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728352299; x=1728957099; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+8jQgQOaevtctAFwb5fQqnwEAqxzOh1/EbEy9uWGmGA=;
        b=hdZ01VkP9S6LYaipu7INrlskP7us8yXxl09fkTHKnngJiY9fC4DCoMgKnwxF7NkUD3
         YYkcgIX5fvYUhu1NxHO+MoUBsm+U2IO5hGJRH0wdCRaZBPt31qdBa0SeyfN4X99eNoPy
         2R+dlDkkFhayttALZb0r8HxQQacS3x7uOf+5QVJzguWSC+k9jGMsnaNIdbrphltaZvkY
         I+ElxeraweCCDantyk6N5o2QfD62CG5hWAJM+gH9upyc5SPvpr2R8QhE2b9Vlt5QLoBJ
         EFmpjkyDdlrLIWZVdmj40JAo6hS7IZpKmnmIXd6aZ0Ic9CJPqK+D+zhfgrn9Y8j9r1Y3
         qlLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728352299; x=1728957099;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+8jQgQOaevtctAFwb5fQqnwEAqxzOh1/EbEy9uWGmGA=;
        b=Al63vHLUcKXWwZdlcCQCd3hlDLxfIjUet4t3Cl+qj1skO3VLGqnfE5v7TFHsJYIQvl
         in6d52yZ06DzLNjxJCeQ/PBUlg9G47I8+AzNyqyqt9jj3sZ5Hu/FVtB9jNo3C8n4bcig
         2bEcmbi0DNdZxeINbNOChqtWqLIQ7Xq4sXkqTAIyHBqmLIhpnelwNeaUSyxya1mF7jPm
         g912DitYeAuGJ7bT0yfa7cWcG52egQ7rncyusQ49T7wPvN1XU7u1d/T4ZamXxi+3H7L/
         St02uBmpqJNazUCAJIcCljLGPcefbUr36ABwd7B+/74OiJA0FrOOmfCEzRY/DnHZXxkR
         v/vQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6FW8jhans+KCl5uzPLcpGjqmLUgNYp6naCUYYF1k2C5uYlzL80QDX+iSsCgSoMETyeG2Ba2H/2c5JLvQ=@vger.kernel.org, AJvYcCVA5rJZ5lqy2r3LI1Rf/SxxNdfYifpguNXSLLan9borFXb5/YDxsHnpIGFlZ4QdaL0B8bA1hjHlvKoN/9NMvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxwPiPj1xxQ/omOo+Z+UNDowDHO77QWS3ATRBM45ALeUVaXKIuN
	BUn4wyX3umN1ACJL/bkYkFRmZhfWc4zrwyX4Sxa2+PIFCzvfd+vP
X-Google-Smtp-Source: AGHT+IHXD6o6/e9xfm8vAvANjXTsFusBkRQIqUbK26nJ0RrhKbccLQ5rwERm4EI/mvxVV45beesioA==
X-Received: by 2002:a17:902:f604:b0:20b:9d96:622c with SMTP id d9443c01a7336-20bfdf800e1mr190206355ad.8.1728352299092;
        Mon, 07 Oct 2024 18:51:39 -0700 (PDT)
Received: from smtpclient.apple ([205.204.117.123])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c138afc95sm46222325ad.2.2024.10.07.18.51.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2024 18:51:38 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] selftests: livepatch: add test case of stack_order sysfs
 interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20241007173909.klwdxcui6slmod2a@treble>
Date: Tue, 8 Oct 2024 09:51:25 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5D4255CE-1AA3-41BB-A6CA-784E60560333@gmail.com>
References: <20241007141139.49171-1-zhangwarden@gmail.com>
 <20241007173909.klwdxcui6slmod2a@treble>
To: Josh Poimboeuf <jpoimboe@kernel.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi, Josh.
> On Oct 8, 2024, at 01:39, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>=20
> On Mon, Oct 07, 2024 at 10:11:39PM +0800, Wardenjohn wrote:
>> Add test case of stack_order sysfs interface of livepatch.
>>=20
>> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
>> ---
>> .../testing/selftests/livepatch/test-sysfs.sh | 24 =
+++++++++++++++++++
>> 1 file changed, 24 insertions(+)
>>=20
>> diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh =
b/tools/testing/selftests/livepatch/test-sysfs.sh
>> index 05a14f5a7bfb..81776749a4e3 100755
>> --- a/tools/testing/selftests/livepatch/test-sysfs.sh
>> +++ b/tools/testing/selftests/livepatch/test-sysfs.sh
>> @@ -19,6 +19,7 @@ check_sysfs_rights "$MOD_LIVEPATCH" "enabled" =
"-rw-r--r--"
>> check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
>> check_sysfs_rights "$MOD_LIVEPATCH" "force" "--w-------"
>> check_sysfs_rights "$MOD_LIVEPATCH" "replace" "-r--r--r--"
>> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
>> check_sysfs_rights "$MOD_LIVEPATCH" "transition" "-r--r--r--"
>> check_sysfs_value  "$MOD_LIVEPATCH" "transition" "0"
>> check_sysfs_rights "$MOD_LIVEPATCH" "vmlinux/patched" "-r--r--r--"
>> @@ -131,4 +132,27 @@ livepatch: '$MOD_LIVEPATCH': completing =
unpatching transition
>> livepatch: '$MOD_LIVEPATCH': unpatching complete
>> % rmmod $MOD_LIVEPATCH"
>>=20
>> +start_test "sysfs test stack_order read"
>> +
>> +load_lp $MOD_LIVEPATCH
>> +
>> +check_sysfs_rights "$MOD_LIVEPATCH" "stack_order" "-r--r--r--"
>> +check_sysfs_value  "$MOD_LIVEPATCH" "stack_order" "1"
>=20
> At the very least this should load more than one module so it can =
verify
> the stack orders match the load order.
>=20
> --=20
> Josh

I got it. And I found more test modules in =
selftests/livepatch/test_modules

I will fix this problem with the modules inside.

Thank you!

Regards.
Wardenjohn.


