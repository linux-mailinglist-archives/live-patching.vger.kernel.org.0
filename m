Return-Path: <live-patching+bounces-127-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1CB4829C5F
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 15:19:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C658B24C59
	for <lists+live-patching@lfdr.de>; Wed, 10 Jan 2024 14:19:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504044B5CD;
	Wed, 10 Jan 2024 14:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="pbWTJyFm"
X-Original-To: live-patching@vger.kernel.org
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFE84B5CB
	for <live-patching@vger.kernel.org>; Wed, 10 Jan 2024 14:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1704896139;
	bh=6mi4okaA7FV0hEPtO9OenJte6wTE47Bvxm6LPo7RW+4=;
	h=Subject:From:To:Date:In-Reply-To:References;
	b=pbWTJyFmIRFQ3XvJ0Fg1XIAzd08xq7r29CU9KdRJRYeXHAm7XnMSwFa6rjn/pwtTm
	 Bs5jdW2ai93nOImE4T0/ulL8D9d20LKwwT7gpgc59gJHAsOHulGj1rVkKDXDe5I/KR
	 hPHMG7wH/uTA7ZnzwOP5wTsMSUcpwA/JAnT9XbtM=
Received: from [192.168.216.104] ([116.2.187.16])
	by newxmesmtplogicsvrszc5-1.qq.com (NewEsmtp) with SMTP
	id 1A784875; Wed, 10 Jan 2024 22:06:39 +0800
X-QQ-mid: xmsmtpt1704895599t31fzbrzz
Message-ID: <tencent_A370A7F1740CD64A13DA74F221EB8B9AC609@qq.com>
X-QQ-XMAILINFO: MB5+LsFw85NoAF0fWjhguWcr0TkvBWnGFKR8AJH26w4v0SNIQ/RJ8w0wDGNEjE
	 qjCnZhKG+0HvTxjBdfPao9CBZmg6J4UjShVUb3B/MSu+cRZot8jTqcvW7lm40d5oKm24geL7cOuD
	 Cg3hJhIJ0oYQ41lgj9/rPRwqnV8st/e+Yf7rNfyltJGEiZKBvmvh1iCSLisWlFkYHBPLxzOyMlbp
	 t2n2z1LiWDAZFmLlAjFc3YqEj3H1hnV7tdRBtqZXJBaeknv3FdwxSK9mmSnSjRRaffCY6BF0AvGJ
	 SZ2utLzJ/DtVj5UkLCaqkyfLuahOiXq8OqmsV8p0v/wx2K2tLsby+HP5Be5+kzWd+5hvcA36ew8B
	 A78+PlRPtyS5B5D1XSdCc72wjU0zWitlJl5B/rTomqLgNjceQ5vxliEeHoQWyg0y0HjEqnPMSMaV
	 JKKEUTlE7YkLp9h5hxGcgLswDdhHGzo5TVky8fGrrqcvzeJZuANGJj7oE7D6QTjTch0Qe3X7+ZUb
	 AzzVgu9nbExOyxNiz45xqCSBl/DzjVRq3zo7cTml80U7jnnYT1l16LTR6qsKxRwKVPTKspnjo5WZ
	 +752rlkn8fL9J62Jchnm4ZQ9Oh4mR8hgiC/Jq+qHtr0XtLElNUlSgHNIBg4gBT6XFHk4UFk7HacL
	 kHJwL9x5Hz7vMxxaHqBPO58TCjw58CwH2wWkTe0Lg9L4sxrd4HGexfbxnVo+SdAXFr0YwgEBQC8g
	 zenA52nu7t13XTm6c/E4OjnalSEetzVwN2YnPq/JMCBTs/JYyrDDipQrMk1MkrddEGWVqan4RN2F
	 fzgdWZEG5jz+gGyrodmBpGY8jxU0hMR7CDhHbsOByHOEEdJLosqYjeJZ/koh2NMs3FnKw7ohvWyu
	 aoUMW0T/LOC2gETFCLsxGQwLct42AMYnuQMVWqH3HGqFX0NnCCWMTwdLDn1tlVb5wer7thVaojNb
	 sAhFUDeCQgLv6HPN4OcmDZcnd2JPnk
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-OQ-MSGID: <01ba8fbd8c2fbf1a6198cf58a1fe977adab201b3.camel@foxmail.com>
Subject: Re: RFC: another way to make livepatch
From: pizza <laokz@foxmail.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>, live-patching@vger.kernel.org
Date: Wed, 10 Jan 2024 22:06:39 +0800
In-Reply-To: <761e2fc21e72576a4704572b50d9fc5b4a1cb9e1.camel@suse.com>
References: <tencent_8B36A9FCE07A8CA645DC6F3C3F039C52E407@qq.com>
	 <761e2fc21e72576a4704572b50d9fc5b4a1cb9e1.camel@suse.com>
Autocrypt: addr=laokz@foxmail.com; prefer-encrypt=mutual;
 keydata=mQINBFzLu4QBEADMp82/D9QivTnSQpsbqOe7pXEIc5faAsUeCIKOuR8aHPFU0ddUrKbQuJ+63lwET+qrSFgdPUUR7QM7TEQWL9Jgiymxn9zhzjOc6MP6AJ58If2MsDQdn5PoDAZC12ERgr9ntsXi+MwaA0VFL6pvROOePyCKmhBLUjUnM3gOUsPauYp3c4oYhRfoJMadESZOeDKUYINZ8UVm+YtL/tJuwMy6QunGPzywe5wQ+Lhncstis55dpWaklkWG6X84MUNk3kSUp8vXgWEWfeRWuLlyd41sHhOFuwpBqZh2nRxskTJmivkEKxifxO+CDXhzFCW8pLb/FVShBmJ+Y/6RKzq4Afl4TxKIGTzXF5zjWr4LwZtLQ0MKHfEB+htfiUGo4TlKx/6Vo5Aqdls1pjv1wzUrbfuDpWu+wf8zyRMV5ku+KAikFlrjFbLi2IleyqGxBRA1LWUUBSnlXDDAjCZOeSFJmeB37hxlOgRl3tCRFvnk3Yu0inlIQHfX4V5YtHrHP9YoRJUfnpuG41uhSf9nJokhW3vnhbH2CmQZBNoWBqvH/E8gCdRBOj0nwA8BNFptSvInUZDlzkjSqbGeGo5fHiBSNS2lGG7uI2BezNFEELA4/F8g0JKvP12SvuBLbo2J7kwqj7wUm/2Ghk8WqWun86kyOzCQCtMaQPIBuun8/Nw32wK3BwARAQABtBlsYW9reiA8bGFva3pAZm94bWFpbC5jb20+iQJXBBMBCABBAhsDBQkFo5qABQsJCAcDBRUKCQgLBRYCAwEAAh4BAheAFiEEm5KEDfHGbzo225HGBu2+68u+gbIFAlzNCScCGQEACgkQBu2+68u+gbIPqxAArF+Q2N38Wn+GFivx7xfXNyK5hMYWkqnre9TAG/++q/0txtwqI7WKuJ6GAWFJSWXvAsvy5Gp4mGGoE6IWs55tTtIdfvfJBcJkRZTZJE7wR8FywoCb7D/LWDEip5XMZipF6
	ZZRlH1i87uQAZtW4Kq0EVmDOkGzCElzx34H83sk1FEjjAA20Q6KJSmad9xAytzCbZu1gJUQzKl9t9/zxgPWXeI+/6aFneN1Bv+Jde4kAgDviib68MUovQt5wSqZBwGE/5I3VdgQzPpC5bHWLj7/EycIHkK04C4ev1EAAk1mw94MsCIAcBnY7I7zTytNBbP15jS4RrgUCDbocS2o7H0WN/wz/EUBF4lKIlxcLGfwqSoGyzNNQ8rw6E7MkkTLJUZCavcYkDNr2ZAYW0EbBTsTBlh67ozExVQM1Dgo4N01RqFOe9uYCzCwpP1nlBzRa7mNb5O1F4L4hROs94f4hXje0cVd+W0PpNaR+iC05lvCVEyHV+dCWnK4cTLVWBuatJ1of6Oj0oF/s2boB35PFW4kD4/oFX7BUoA8U/Lf8NarOev3DIXkRNwOFL1lBClgMXFFoNFmj3xWrJaUAkil7FNEilZg/HVuTeaZNXZrGR9NWR6ZgDuyeS660XIEr3VqdTsplQF49nSUul64NNoRdgdXB2Or6SGq0egPx7FPthCXzi4=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2-1 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-01-10 at 08:52 -0300, Marcos Paulo de Souza wrote:
> On Thu, 2023-12-21 at 22:06 +0800, laokz wrote:
> > Hi,
> >=20
> > Is it off-topic talking about livepatch making tool? I tried another
> > way and
> > want to get your expert opinion if there any fatal pitfall.
>=20
> I don't think it's out of scope, but what exactly you mean by "another

Thanks.

> way to make livepatch"? You would like to know about different
> approaches like source-based livepatch compared to kpatch, or you mean

Yes, exactly. Inspired by kpatch, I tried to make livepatch on source level
to avoid difficult binary hacking, just like what we did normal module
development. The main idea is similar to some topics of this mail list,

1. Write livepatch-sample.c stylish source code, put all needed non-
export/non-include symbols(I call them KLPSYMs) declarations in file.
2. Generate KLPSYMs position information through kallsyms etc.
3. `KBUILD_MODPOST_WARN=3D1 make` to build a "partial linked" .ko.
4. Use a klp-convert like tool to transform the KLPSYMs.

For simple patch, hand-write source might be easy though a little time
consuming. I used libclang to auto abbreviate livepatch source[1].=C2=A0

The main obstacle, IMO, is "how to determine non-included local symbols",
because they might be inlined, optimized out, duplicate names, mangled
names, and because kallsyms, vmlinux .symtab less some verbose information.
In my toy, I used DWARF along with kallsyms to try to verify all of them.=
=C2=A0

But now I realized that DWARF might be the fatal pitfall. That's a pity. I
still get hope that's not too bad:)

[1] https://gitee.com/laokz/klpmake
[2] mirror: https://github.com/laokz/klpmake

> something different?
>=20
> Thanks!
>=20
> >=20
> > Thanks.
> >=20
> > laokz
> >=20
> >=20
>=20
>=20


