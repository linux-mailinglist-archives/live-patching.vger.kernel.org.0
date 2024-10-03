Return-Path: <live-patching+bounces-707-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9472D98E9B6
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2024 08:26:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64B3D1F23D2A
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2024 06:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 882A577F10;
	Thu,  3 Oct 2024 06:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PeJ+39Eo"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C253B67A;
	Thu,  3 Oct 2024 06:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727936796; cv=none; b=jLkXiIqPvQDx5542UkEI+IzsgARQwSgGyQ9efcwOmiHhTnJ/n6B9jHBAwOWxGwNXT7AbTksfq5YqUHBYmKYeNnoMNZ6mHpC7zzk0lmKEqiglG0E34gqRYouJjVGanGpKxmppPLs/JirCknl3V+HkvN7DZciwVHEfIcMtHS3BLso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727936796; c=relaxed/simple;
	bh=anqtMKa37Qv93xRdwitdM+YKzrs8QNqDAwtN6++ANhw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YETg9qTQzz8yjLzvxPMuyaPyIegNF+oz3LWghVzFHYG1yVIqZCGpOOl2Uae6Yl1K7BHGnsOfzjl/GN0vkEU3sVXGIypW+kTcSGoHXzV1HQ/vXuxMruLm7IkX/aLMUyuY1FoUrLKJ6X55vCnByg0yYbyE55bCQvdbCB6xIGxBmuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PeJ+39Eo; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-71971d2099cso537599b3a.2;
        Wed, 02 Oct 2024 23:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727936794; x=1728541594; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehx7zcniFSJvusQe4grgpCaQ/sYo8xLGvQULqrZ/W54=;
        b=PeJ+39EolAdHzGMauFFKEMHEJ/EhUPDexs2l0D/n3MLIsF0KUtmk+pxoYm8NgC2Qd8
         G4KYoIfj3y3/xwRj4W7k4bHqS2y8HKoMmv9nhn0Hva2LsIdNBxtyLz8YrPDUgf0lQbso
         QJ9iW+6xHsP36WP/EuuP7UzyWxrhFIUzX/mc/9kG+c8ZX/uINycbVm9wLZLKyaLiXqll
         aewKtFBuApiXh3ffkoKFnwZc/E/QosCGvY9sr5JoRCeYQEizezgqZAFnyXeE7YYdoQkW
         mJh0z1ftHaZ5dagh2fiwaOG/rnaYtLr0+Ps8gES0GB8N2vrynx3pFu43CUUOgHPV/FyB
         rYGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727936794; x=1728541594;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ehx7zcniFSJvusQe4grgpCaQ/sYo8xLGvQULqrZ/W54=;
        b=wZEw7fGjtqHIadvLKFichrm/Wem5iAdqkGwPVLsDjKn/MXYoxbxR9BAoRNG4SFIjNi
         2G2XmY94nxQL6nxNxUIUMI07r3SDdilGL2QsXENZ3du6TasVYK4nhO/Z+kzYka04sNNg
         lw+CwnbeGPqr8shGSoG4/sGjQgTC0RAqRAhV/6MxoWvGyjoIcH4JbmODFCze6I9TYbi+
         +ePkMKRR+eCTo3cxRPRPmd5xGABawhfd1DuE+SEMJX0vYD2i33Al+NX+Mv550uiK5z9E
         YJInz4PKxuxgzcOVetE+llbGln0kg5BV0AVMiBfab4QcZhXQFkdHJ5t/M02ohzDpZ3rZ
         iLRw==
X-Forwarded-Encrypted: i=1; AJvYcCWZGHZfBYouGLPzWg1BxAE9to00bkOGbELWPe97Dy6Kp8pccpJwVM19G5GIV6g4ZfJmv4bihEobNLB62+A=@vger.kernel.org, AJvYcCWaAguS3qAGK3AXUkD7jpnKjkH81+cp0RY8XM3MvayjvQNLYgnnWmw5puTn+2c0PjH9NskxRiaEXyKRwLYLOg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz227LK5DgIkxThMW1oPEOSWYmIIX0I8r3GqF7uQ/wgRp6rKfE/
	RGMxrRxaZVMDktEVZhgBehn73axvZ6LXLM9inb6xGjZEqpyawkE75fww6nl5i7k=
X-Google-Smtp-Source: AGHT+IFVL4RWcFWi+jUDrYQi/9f+9ZXrCTuXIih7GcD+BghYUUXcv+04fvaXfZMohHM+vzIr2Bemgw==
X-Received: by 2002:a05:6a00:3c90:b0:718:532f:5a3 with SMTP id d2e1a72fcca58-71dc5c78167mr9354682b3a.7.1727936794214;
        Wed, 02 Oct 2024 23:26:34 -0700 (PDT)
Received: from smtpclient.apple ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e9dbcf0d1dsm140023a12.3.2024.10.02.23.26.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2024 23:26:33 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH V3 1/1] livepatch: Add "stack_order" sysfs attribute
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20240930232600.ku2zkttvvkxngdmc@treble>
Date: Thu, 3 Oct 2024 14:26:19 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <14D5E109-9389-47E7-A3D6-557B85452495@gmail.com>
References: <20240929144335.40637-1-zhangwarden@gmail.com>
 <20240929144335.40637-2-zhangwarden@gmail.com>
 <20240930232600.ku2zkttvvkxngdmc@treble>
To: Josh Poimboeuf <jpoimboe@kernel.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi, Josh!
> On Oct 1, 2024, at 07:26, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>>=20
>> diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch =
b/Documentation/ABI/testing/sysfs-kernel-livepatch
>> index a5df9b4910dc..2a60b49aa9a5 100644
>> --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
>> +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
>> @@ -47,6 +47,14 @@ Description:
>> disabled when the feature is used. See
>> Documentation/livepatch/livepatch.rst for more information.
>>=20
>> +What:           /sys/kernel/livepatch/<patch>/stack_order
>> +Date:           Sep 2024
>> +KernelVersion:  6.12.0
>=20
> These will probably need to be updated (can probably be done by Petr =
when
> applying).
>=20
True, kernel version may need Petr to decide.

>> +Contact:        live-patching@vger.kernel.org
>> +Description:
>> + This attribute holds the stack order of a livepatch module applied
>> + to the running system.
>=20
> It's probably a good idea to clarify what "stack order" means.  Also,
> try to keep the text under 80 columns for consistency.
>=20
> How about:
>=20
> This attribute indicates the order the patch was applied
> compared to other patches.  For example, a stack_order value of
> '2' indicates the patch was applied after the patch with stack
> order '1' and before any other currently applied patches.
>=20

Or how about:

This attribute indicates the order of the livepatch module=20
applied to the system. The stack_order value N means=20
that this module is the Nth applied to the system. If there
are serval patches changing the same function, the function
version of the biggest stack_order is enabling in the system.

Regards.
Wardenjohn.



