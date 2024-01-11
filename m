Return-Path: <live-patching+bounces-139-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 56CF482B129
	for <lists+live-patching@lfdr.de>; Thu, 11 Jan 2024 15:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2624EB23F54
	for <lists+live-patching@lfdr.de>; Thu, 11 Jan 2024 14:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C1F2207D;
	Thu, 11 Jan 2024 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="O0kzL6LI"
X-Original-To: live-patching@vger.kernel.org
Received: from out203-205-221-153.mail.qq.com (out203-205-221-153.mail.qq.com [203.205.221.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2761D15E96
	for <live-patching@vger.kernel.org>; Thu, 11 Jan 2024 14:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1704984751;
	bh=59Bjcjj9zOU2lDO+XIXFKXpraDndBLyzeSUX3z6A1B4=;
	h=Subject:From:To:Date:In-Reply-To:References;
	b=O0kzL6LICzC/NOvGeZvqr1fKDD2IILx7LqTTDNiOcr7Kflud+p51S5lQ+i5W5EXQQ
	 54UBH9s4bBPOoFnWTrxEyRYm11ESyp2uNAaNiM+5Ld5lRKs+NVjX+L69Yuf4YffIqT
	 3j/GdUWI1UslFTvUNEnMX6S9iHn1z1RraQOuQZfM=
Received: from [192.168.216.104] ([113.233.131.72])
	by newxmesmtplogicsvrszc5-0.qq.com (NewEsmtp) with SMTP
	id D1D9E8CA; Thu, 11 Jan 2024 22:52:29 +0800
X-QQ-mid: xmsmtpt1704984749t9vilysjo
Message-ID: <tencent_CE0CF5394D67B86478EE069BA57C6D0EF908@qq.com>
X-QQ-XMAILINFO: NssJ/YX50roaLRmemsKEk2BaGpmFfeNo7g8gigORQ8aUGo0b5NKY1faCIv/jMz
	 YGtlZaG40SgO7PFgMgIv9WZOrM0X6hsqiLzBWNZ8paYj/VHUwEQXUNPB30VbzuM0C+UXDZLXE/6m
	 /ni4yU8CU+nPeLZMjwt7twT1/iLLdxv4Z/lzkCwxLSan2/wKnQoYkmTfERhdNXbdQ+WMiIh935X8
	 dGFMvfyNM3nlehCFGvI2T22WADI82f7VDWk2fKPVKEJYyfi7dYty4VpsLJ+r78jjNWhIaMHwJpip
	 cLiNBhrbg4d6lxlCu0lFWYDeaMuhwLK3DrCqNyLdGTJkybygHk9oxKPaAynEZcaFIKMQvKfHG2Z0
	 V7vRmAipgsHLNNNQmnNcP8UaxwhF5E3jBfYG/KB00VWrXtj0uAZ9Dhkv640Vvo0Y7holFmzNUlIW
	 LfPj6Q5k8RlV1OIj5KKABGoGjxbn+FDMIa/Cv5r4SlHlhi5BSAPdc9YwP3O2En3xjRZxZSZZUMvd
	 yVglVuow4Y4rNyOTTvNm8r4A/HhnDP00zRwLrwhw9XicBrvPJ1O46PQIdIfvPobEHP9A0A6d0DR7
	 06xvex/0T+4TbRO0Etf2Pu4pboy/YNjMru6djhBpzPVgd2GA2K4uSdfZOSf0ro5qjQhQEaqUX06N
	 009rmj5fQNq0xa/+IfhtP6tdq989hGZggv2SMXjEbUBkYBqG4r53wfTCS6Xpb6fN/UjVtwCBj3/F
	 /YYssCQCey49c4I5JZC4VE/WUgnsn/lMwNI2nrhpAr5bdJZ+SRODKtOB/2BzioLkfVw0hXQVt6Fr
	 ANrehrDHZagm85HzmxDvfFyWO6aSnXywioGIgNIMjcz4cr8Q7EIdTNbLypBIwiIYODj2DBEacNQf
	 uT1wv1sO0XTBA2JagdjifqNwZModLKbfS0oy5J/dsh
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
X-OQ-MSGID: <0e7e9c11933f181b7862062b487770c3c76bc02d.camel@foxmail.com>
Subject: Re: RFC: another way to make livepatch
From: laokz <laokz@foxmail.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>, live-patching@vger.kernel.org
Date: Thu, 11 Jan 2024 22:52:29 +0800
In-Reply-To: <9f15ca09d5d7ea65044795bc3ef5dfa2ad1fb84d.camel@suse.com>
References: <tencent_8B36A9FCE07A8CA645DC6F3C3F039C52E407@qq.com>
	 <761e2fc21e72576a4704572b50d9fc5b4a1cb9e1.camel@suse.com>
	 <tencent_A370A7F1740CD64A13DA74F221EB8B9AC609@qq.com>
	 <9f15ca09d5d7ea65044795bc3ef5dfa2ad1fb84d.camel@suse.com>
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

On Wed, 2024-01-10 at 13:28 -0300, Marcos Paulo de Souza wrote:
> On Wed, 2024-01-10 at 22:06 +0800, pizza wrote:
> > On Wed, 2024-01-10 at 08:52 -0300, Marcos Paulo de Souza wrote:
> > > On Thu, 2023-12-21 at 22:06 +0800, laokz wrote:
> > > > Hi,
> > > >=20
> > > > Is it off-topic talking about livepatch making tool? I tried
> > > > another
> > > > way and
> > > > want to get your expert opinion if there any fatal pitfall.
> > >=20
> > > I don't think it's out of scope, but what exactly you mean by
> > > "another
> >=20
> > Thanks.
> >=20
> > > way to make livepatch"? You would like to know about different
> > > approaches like source-based livepatch compared to kpatch, or you
> > > mean
> >=20
> > Yes, exactly. Inspired by kpatch, I tried to make livepatch on source
> > level
> > to avoid difficult binary hacking, just like what we did normal
> > module
> > development.
>=20
> This is how we create livepatches at SUSE.
>=20
> > The main idea is similar to some topics of this mail list,
> >=20
> > 1. Write livepatch-sample.c stylish source code, put all needed non-
> > export/non-include symbols(I call them KLPSYMs) declarations in file.
> > 2. Generate KLPSYMs position information through kallsyms etc.
> > 3. `KBUILD_MODPOST_WARN=3D1 make` to build a "partial linked" .ko.
> > 4. Use a klp-convert like tool to transform the KLPSYMs.
>=20
> For now we are using kallsyms to get the address of the symbols, but it
> will be changed soon due to IBT. The plan here is to also use klp-
> convert.
>=20
> >=20
> > For simple patch, hand-write source might be easy though a little
> > time
> > consuming. I used libclang to auto abbreviate livepatch source[1].
> >=20
> > The main obstacle, IMO, is "how to determine non-included local
> > symbols",
> > because they might be inlined, optimized out, duplicate names,
> > mangled
> > names, and because kallsyms, vmlinux .symtab less some verbose
> > information.
> > In my toy, I used DWARF along with kallsyms to try to verify all of
> > them.=C2=A0
> >=20
>=20
> That's is the tricky part, indeed.
>=20
> > But now I realized that DWARF might be the fatal pitfall. That's a
> > pity. I
> > still get hope that's not too bad:)
>=20
> Interesting. I didn't checked your code, but I can explain how we are
> doing things now, and how we plan to do in the future.
>=20
> Currently we are using klp-ccp[3] to extract the functions for us. The
> tool also requires the ELF object that we are patching, plus Symvers
> file and the ipa-clones generated when the kernel was compiled. This
> way we can detect the symbols that are public (exported by vmlinux),
> public from modules (exported by other modules), and private (exported
> by the patched module).
>=20
> For the symbols from vmlinux, we depend on them and call them directly.
> For symbols from modules and private symbols, we use kallsyms to get
> their address in order to call them.
>=20
> For optimized symbols, we usually check the callers of the symbol
> manually.
>=20
> We also use a tool called klp-build (we plan to open source it later
> this year) to detect duplicated symbols, check if the same symbol is
> available and not optimized in different architectures (since we create
> livepatches for three different architectures), and to check later if
> the code generated/patches doesn't rely on symbols from other modules.
>=20
> What we are doing right now is a new tool that uses LLVM/libclang to
> extract the functions. The new tool also relies on the same
> dependencies: module to be patched (to read the symbol table), Symvers
> and ipa-clones. The main advantage of it is to rely on LLVM's AST. We
> also plan to release this tool later this year. Another interesting
> aspect of the new tool is that our userspace livepatching team was who
> created the tool, and are using it to create their livepatches. Kernel
> supported was added to it afterwards.
>=20
> We plan to advertise both tools in this ML when they are released,
> since we use both to create LPs today (klp-build is used currently with
> klp-ccp already, but supported for the new tool is already done, but
> not production ready).
>=20
> Stay tuned :)
>=20

Thanks for sharing the information. Coping with compiler optimization is
another big pitfall,, Right, I'll stay tuned with your good news)


> >=20
> > [1] https://gitee.com/laokz/klpmake
> > [2] mirror: https://github.com/laokz/klpmake
> [3]: https://github.com/SUSE/klp-ccp
> >=20
> > > something different?
> > >=20
> > > Thanks!
> > >=20
> > > >=20
> > > > Thanks.
> > > >=20
> > > > laokz
> > > >=20
> > > >=20
> > >=20
> > >=20
> >=20
>=20
>=20


