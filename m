Return-Path: <live-patching+bounces-1233-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC172A45BA8
	for <lists+live-patching@lfdr.de>; Wed, 26 Feb 2025 11:24:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12ECE1888B8F
	for <lists+live-patching@lfdr.de>; Wed, 26 Feb 2025 10:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A59A23814F;
	Wed, 26 Feb 2025 10:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TNLGq8b8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1DC226D1E;
	Wed, 26 Feb 2025 10:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740565422; cv=none; b=fpVp+s2pk6KCmVWRFpqnebbD0Ze3dwjgosWDg+1IXOH0x2WZvXYjeHlebnXeWOjnC75UzTaLnt2eSGQh20ueEyVM3sI1Mr4O/mZ3Xjb4nJEd8RHHJzcYw5ior0/FKE2MyStprHnr/eRaeGLOW4Bmyh7uIklgZpo6pganY3IECwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740565422; c=relaxed/simple;
	bh=JUYF30zXLkCS1lAA8rBTYOxggTmbkwCo5KuReiWez2o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RLSzEo0Co8agMIpfLdxx7Xg47BuVUpvhQ043zc7NI/VJsJ+xTJCY4iUV0aH+xnbI+AEO91eSAbifttFxfOB0PSU5J0THyvh97kuDNJEcMEGJef4XLlD9aiwNZ7mqyoloGHn3tOZKNupowG0mJFJqwo3d2hsg24m8XwqJSJSuw8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TNLGq8b8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E03AC4CED6;
	Wed, 26 Feb 2025 10:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740565419;
	bh=JUYF30zXLkCS1lAA8rBTYOxggTmbkwCo5KuReiWez2o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=TNLGq8b80js9FyHVPJjRXtMKtsdmapm9jAuzG5Hu8ao0CiQpzZkK0U1QubINKmTVx
	 AcSAxsKGHycnY+Wacg1SZRuMsEcn1L/wiKM0Jtazx8N9rk56mqqidAYIwHOfVbO104
	 7PPfufh538BcG64ZMbEYc+KviyAlj3E48I140tiVcn8b0R/khClmclunV6HdhBezTg
	 JbQWHV7Y8GSzv//TPYb5RN2TnTdkh0VLpw3Qi10jpTX5BmjN++bNC4aEiTV1nj8vnF
	 bzkH/yf4XagpI5UX/0L+pZmbfhiAHr7nkezIVAGOmOKcfN2b4HP0IzIAonw3MoDHuE
	 zg11Pvxb405qA==
From: Puranjay Mohan <puranjay@kernel.org>
To: Indu Bhagat <indu.bhagat@oracle.com>, Weinan Liu <wnliu@google.com>
Cc: irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org,
 mark.rutland@arm.com, peterz@infradead.org, roman.gushchin@linux.dev,
 rostedt@goodmis.org, will@kernel.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
In-Reply-To: <da6aad99-3461-47fd-b9d8-65f8bb446ae1@oracle.com>
References: <4356c17a-8dba-4da0-86dd-f65afb8145e2@oracle.com>
 <20250225235455.655634-1-wnliu@google.com>
 <da6aad99-3461-47fd-b9d8-65f8bb446ae1@oracle.com>
Date: Wed, 26 Feb 2025 10:23:21 +0000
Message-ID: <mb61ph64h9f8m.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Indu Bhagat <indu.bhagat@oracle.com> writes:

> On 2/25/25 3:54 PM, Weinan Liu wrote:
>> On Tue, Feb 25, 2025 at 11:38=E2=80=AFAM Indu Bhagat <indu.bhagat@oracle=
.com> wrote:
>>>
>>> On Mon, Feb 10, 2025 at 12:30=E2=80=AFAM Weinan Liu <wnliu@google.com> =
wrote:
>>>>> I already have a WIP patch to add sframe support to the kernel module.
>>>>> However, it is not yet working. I had trouble unwinding frames for the
>>>>> kernel module using the current algorithm.
>>>>>
>>>>> Indu has likely identified the issue and will be addressing it from t=
he
>>>>> toolchain side.
>>>>>
>>>>> https://sourceware.org/bugzilla/show_bug.cgi?id=3D32666
>>>>
>>>> I have a working in progress patch that adds sframe support for kernel
>>>> module.
>>>> https://github.com/heuza/linux/tree/sframe_unwinder.rfc
>>>>
>>>> According to the sframe table values I got during runtime testing, loo=
ks
>>>> like the offsets are not correct .
>>>>
>>>
>>> I hope to sanitize the fix for 32666 and post upstream soon (I had to
>>> address other related issues). =C2=A0Unless fixed, relocating .sframe
>>> sections using the .rela.sframe is expected to generate incorrect outpu=
t.
>>>
>>>> When unwind symbols init_module(0xffff80007b155048) from the kernel
>>>> module(livepatch-sample.ko), the start_address of the FDE entries in t=
he
>>>> sframe table of the kernel modules appear incorrect.
>>>
>>> init_module will apply the relocations on the .sframe section, isnt it ?
>>>
>>>> For instance, the first FDE's start_addr is reported as -20564. Adding
>>>> this offset to the module's sframe section address (0xffff80007b15a040)
>>>> yields 0xffff80007b154fec, which is not within the livepatch-sample.ko
>>>> memory region(It should be larger than 0xffff80007b155000).
>>>>
>>>
>>> Hmm..something seems off here. =C2=A0Having tested a potential fix for =
32666
>>> locally, I do not expect the first FDE to show this symptom.
>>>
>>=20

Hi,

Sorry for not responding in the past few days.  I was on PTO and was
trying to improve my snowboarding technique, I am back now!!

I think what we are seeing is expected behaviour:

 | For instance, the first FDE's start_addr is reported as -20564. Adding
 | this offset to the module's sframe section address (0xffff80007b15a040)
 | yields 0xffff80007b154fec, which is not within the livepatch-sample.ko
 | memory region(It should be larger than 0xffff80007b155000).


Let me explain using a __dummy__ example.

Assume Memory layout before relocation:

 | Address | Element                                 | Relocation
 |  ....   | ....                                    |
 |   60    | init_module (start address)             |
 |   72    | init_module (end address)               |
 |  ....   | .....                                   |
 |   100   | Sframe section header start address     |
 |   128   | First FDE's start address               | RELOC_OP_PREL -> Put=
 init_module address (60) - current address (128)

So, after relocation First FDE's start address has value 60 - 128 =3D -68

Now, while doing unwinding we Try to add this value to the sframe
section header's start address which is in this example 100,

so 100 + (-68) =3D 32

So, 32 is not within [60, 72], i.e. within init_module.

You can see that it is possible for this value to be less than the start
address of the module's memory region when this function's address is
very close to the start of the memory region.

The crux is that the offset in the FDE's start address is calculated
based on the address of the FDE's start_address and not based on the
address of the sframe section.


Thanks,
Puranjay

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEARYKADIWIQQ3wHGvVs/5bdl78BKwwPkjG3B2nQUCZ77rmxQccHVyYW5qYXlA
a2VybmVsLm9yZwAKCRCwwPkjG3B2ncczAP9XQv1qvG5QCEfqUBX3HHJF4cyv8eWB
B49aFu+bqtdZ/wEArbSbRVLmpy9+45qoLpOywsiqw6sK+Dtw6vwAGxJX7ws=
=hyPk
-----END PGP SIGNATURE-----
--=-=-=--

