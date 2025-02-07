Return-Path: <live-patching+bounces-1129-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 916F8A2C277
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 13:18:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7B953A94B2
	for <lists+live-patching@lfdr.de>; Fri,  7 Feb 2025 12:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E941E0DEB;
	Fri,  7 Feb 2025 12:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t1Xn2gmI"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD94B1DF74B;
	Fri,  7 Feb 2025 12:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738930605; cv=none; b=SvAjNPzMZ4CT2UQTLshPDMhbelw7DnNnRAx5aFigoD7BvxHqEc2mqaWxmWEvcalbctllC0uGXYCGjP+aQeHtnPBFtkK9lrIp0nl6fwxnV9YEdf2gvfZmdOEe7yef+QQM9uX3QuN6HVwSBCGOCBFu3xbPmB1Rv85bwgPukslV8iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738930605; c=relaxed/simple;
	bh=7e6g6OCkpwbbGI6SHOEt+loTWxRQZEpgL2ZxwiU3pfc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=idZ8IQjI0l8azWlGanVB3Tw8skEJ8RrjJOalP9GWEcQXXnOopMCJioK3xYq7OK4Nx1i+u78GXm4u2NVdrU9H7Moa22cmTsJ6uXj2AXcJJpR6QJltqOyX8xR060Sy5AD2d85DRyGMCnjokh8ki4uMkU9zervw8OYuAdPS3/fKhmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t1Xn2gmI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F60C4CED1;
	Fri,  7 Feb 2025 12:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738930604;
	bh=7e6g6OCkpwbbGI6SHOEt+loTWxRQZEpgL2ZxwiU3pfc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=t1Xn2gmIPvrMZ4ok0mbMF6xEGiKb/RzmjTckImIFK+fAeGe18AdXJMDrLt5ONgToA
	 WTZCr5WwcJPLWgBSm10IP9hIypCtTmMOAgP3m41PebT/YFwirJqa6+Mj0jeIl8F8lQ
	 q1IhM40wChU9JOjTj0uOddf6HuRoer+Y9sRZdcFLuG3RD8J1AjJw5/VlMgADvm/0jJ
	 DK5KYZg2sPWlJa1KsH5bUjcVd/FNUZj4v5PlGfGSTYPZgaKh3yOWz+xWbkRqiryV5s
	 FQVKCm4laIkRmDcX58nh1YEK2UMR4Z4SzTuimBypWfPMwPCt39cxJhtPC6BfRk1sNC
	 eFhZpVKkmN1Ug==
From: Puranjay Mohan <puranjay@kernel.org>
To: Weinan Liu <wnliu@google.com>
Cc: indu.bhagat@oracle.com, irogers@google.com, joe.lawrence@redhat.com,
 jpoimboe@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-toolchains@vger.kernel.org,
 live-patching@vger.kernel.org, mark.rutland@arm.com, peterz@infradead.org,
 roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org,
 wnliu@google.com
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
In-Reply-To: <20250206150212.2485132-1-wnliu@google.com>
References: <mb61pwme55kuw.fsf@kernel.org>
 <20250206150212.2485132-1-wnliu@google.com>
Date: Fri, 07 Feb 2025 12:16:29 +0000
Message-ID: <mb61pikpm3q76.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Weinan Liu <wnliu@google.com> writes:

>> After some debugging this is what I found:
>>=20
>> devtmpfsd() calls devtmpfs_work_loop() which is marked '__noreturn' and =
has an
>> infinite loop. The compiler puts the `bl` to devtmpfs_work_loop() as the=
 the
>> last instruction in devtmpfsd() and therefore on entry to devtmpfs_work_=
loop(),
>> LR points to an instruction beyond devtmpfsd() and this consfuses the un=
winder.
>>=20
>> ffff800080d9a070 <devtmpfsd>:
>> ffff800080d9a070:       d503201f        nop
>> ffff800080d9a074:       d503201f        nop
>> ffff800080d9a078:       d503233f        paciasp
>> ffff800080d9a07c:       a9be7bfd        stp     x29, x30, [sp, #-32]!
>> ffff800080d9a080:       910003fd        mov     x29, sp
>> ffff800080d9a084:       f9000bf3        str     x19, [sp, #16]
>> ffff800080d9a088:       943378e8        bl      ffff800081a78428 <devtmp=
fs_setup>
>> ffff800080d9a08c:       90006ca1        adrp    x1, ffff800081b2e000 <un=
ique_processor_ids+0x3758>
>> ffff800080d9a090:       2a0003f3        mov     w19, w0
>> ffff800080d9a094:       912de021        add     x1, x1, #0xb78
>> ffff800080d9a098:       91002020        add     x0, x1, #0x8
>> ffff800080d9a09c:       97cd2a43        bl      ffff8000800e49a8 <comple=
te>
>> ffff800080d9a0a0:       340000d3        cbz     w19, ffff800080d9a0b8 <d=
evtmpfsd+0x48>
>> ffff800080d9a0a4:       2a1303e0        mov     w0, w19
>> ffff800080d9a0a8:       f9400bf3        ldr     x19, [sp, #16]
>> ffff800080d9a0ac:       a8c27bfd        ldp     x29, x30, [sp], #32
>> ffff800080d9a0b0:       d50323bf        autiasp
>> ffff800080d9a0b4:       d65f03c0        ret
>> ffff800080d9a0b8:       97f06526        bl      ffff8000809b3550 <devtmp=
fs_work_loop>
>> ffff800080d9a0bc:       00000000        udf     #0
>> ffff800080d9a0c0:       d503201f        nop
>> ffff800080d9a0c4:       d503201f        nop
>>=20
>> find_fde() got pc=3D0xffff800080d9a0bc which is not in [sfde_func_start_=
address, sfde_func_size)
>>=20
>> output for readelf --sframe for devtmpfsd()
>>=20
>> func idx [51825]: pc =3D 0xffff800080d9a070, size =3D 76 bytes
>>     STARTPC           CFA       FP        RA
>>     ffff800080d9a070  sp+0      u         u
>>     ffff800080d9a07c  sp+0      u         u[s]
>>     ffff800080d9a080  sp+32     c-32      c-24[s]
>>     ffff800080d9a0b0  sp+0      u         u[s]
>>     ffff800080d9a0b4  sp+0      u         u
>>     ffff800080d9a0b8  sp+32     c-32      c-24[s]
>>=20
>> The unwinder and all the related infra is assuming that the return addre=
ss
>> will be part of a valid function which is not the case here.
>>=20
>> I am not sure which component needs to be fixed here, but the following
>> patch(which is a hack) fixes the issue by considering the return address=
 as
>> part of the function descriptor entry.
>>=20
>> -- 8< --
>>=20
>> diff --git a/kernel/sframe_lookup.c b/kernel/sframe_lookup.c
>> index 846f1da95..28bec5064 100644
>> --- a/kernel/sframe_lookup.c
>> +++ b/kernel/sframe_lookup.c
>> @@ -82,7 +82,7 @@ static struct sframe_fde *find_fde(const struct sframe=
_table *tbl, unsigned long
>>         if (f >=3D tbl->sfhdr_p->num_fdes || f < 0)
>>                 return NULL;
>>         fdep =3D tbl->fde_p + f;
>> -       if (ip < fdep->start_addr || ip >=3D fdep->start_addr + fdep->si=
ze)
>> +       if (ip < fdep->start_addr || ip > fdep->start_addr + fdep->size)
>>                 return NULL;
>>=20
>>         return fdep;
>> @@ -106,7 +106,7 @@ static int find_fre(const struct sframe_table *tbl, =
unsigned long pc,
>>         else
>>                 ip_off =3D (int32_t)(pc - (unsigned long)tbl->sfhdr_p) -=
 fdep->start_addr;
>>=20
>> -       if (ip_off < 0 || ip_off >=3D fdep->size)
>> +       if (ip_off < 0 || ip_off > fdep->size)
>>                 return -EINVAL;
>>=20
>>         /*
>>=20
>> -- >8 --
>>=20
>> Thanks,
>> Puranjay
>
> Thank you for reporting this issue.
> I just found out that Josh also intentionally uses '>' instead of '>=3D' =
for the same reason
> https://lore.kernel.org/lkml/20250122225257.h64ftfnorofe7cb4@jpoimboe/T/#=
m6d70a20ed9f5b3bbe5b24b24b8c5dcc603a79101
>
> QQ, do we need to care the stacktrace after '__noreturn' function?

Yes, I think we should, but others people could add more to this.

I have been testing this series with Kpatch and created a PR that works
with this unwinder: https://github.com/dynup/kpatch/pull/1439

For the modules, I think we need per module sframe tables that are
initialised when the module is loaded. And the unwinder should use the
module specific table if the IP is in a module's code.

Have you already started working on it? if not I would like to help and
work on that.

Thanks,
Puranjay

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEARYKADIWIQQ3wHGvVs/5bdl78BKwwPkjG3B2nQUCZ6X5nhQccHVyYW5qYXlA
a2VybmVsLm9yZwAKCRCwwPkjG3B2nYmvAPwPT53bFmRfLn+t4r+dsnHeYai0TZrr
f0qZrEfx2fOnxAEA2fy5HjDlJx+1cO4Mc/JA9gxF74wiZOOUxwFwou7jlwc=
=ZyLG
-----END PGP SIGNATURE-----
--=-=-=--

