Return-Path: <live-patching+bounces-627-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F9096FF0D
	for <lists+live-patching@lfdr.de>; Sat,  7 Sep 2024 03:47:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C87D3285F7B
	for <lists+live-patching@lfdr.de>; Sat,  7 Sep 2024 01:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFA2C125;
	Sat,  7 Sep 2024 01:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIoOWH40"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94520D51E;
	Sat,  7 Sep 2024 01:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725673628; cv=none; b=Vnetdrdb0uiFNW+YZjEhWoVaKZbWTXz0dKFIQ5b4JAME3eP1I0oDOZWbHWb1/YHCFe/J6kyN40gvxCehF91ajD9UloLZyy7/jewMTLchV7wUYQM/o7mdGgeake3albxIYpStt+gKGiXk5gDlneVSoy1LL3W4/3lZ/30hx3K83dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725673628; c=relaxed/simple;
	bh=+hziEI1rjD1w2MJaKKVzbO9hyJSX3CmV8H47oi3Xqwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uIYIPGFkAOL/x8bk0Drjg5clp8OvpDd/TCoXVWCrl/qVaAYyIOHfFaxN3t9VeKtsmYIKE4KzZGKHEcpzFuG7qXvtRWNGtDszCGsmdCvmJGC5xo6309GYXh05f1vZ0nQdXwojoYAW0iJr+Levxoj6LOL8Fnnmv59/Kn2pt7u5GPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIoOWH40; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A312DC4CEC4;
	Sat,  7 Sep 2024 01:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725673628;
	bh=+hziEI1rjD1w2MJaKKVzbO9hyJSX3CmV8H47oi3Xqwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lIoOWH40lFJtsAYMBip2uNgYg/13Nrzy5Gw09FCuqlV31ybKjIeQdJtpb2OpDk7sD
	 pNWxz58EHOfwsRgv6tsk+3YTC4ypcInRIk9cCH9fsNEl8yVF15sX4zv1tc9XJ1XOyZ
	 GYDl6QB3aaNF7TDcOoJWtw1Yuv9apD9NVAstN2/hOagTpyJp6UptHP7txCTPGjy/Ty
	 mmBH3xFUUEnPcOPUy7qUpfETCrDD9l2gMWev/HHJIfMr77m/kClskKlhVY4xXY4DvI
	 j1de5JDQINroLxoXpZT2T07hnBFYt2prRp7KewSvdyhuODEpE20qICnfwOEoipbL00
	 wObJLlSKq+BQg==
Date: Fri, 6 Sep 2024 18:47:06 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <20240907014706.hw57colm6caxotyw@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <ZtsJ9qIPcADVce2i@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtsJ9qIPcADVce2i@redhat.com>

On Fri, Sep 06, 2024 at 09:56:06AM -0400, Joe Lawrence wrote:
> A few minor build complaints on my system:
> 
>   $ make tools/objtool/check.o
>     CALL    scripts/checksyscalls.sh
>     DESCEND objtool
>     INSTALL libsubcmd_headers
>     CC      /home/jolawren/src/linux/tools/objtool/check.o
>   check.c: In function ‘is_livepatch_module’:
>   check.c:661:16: error: implicit declaration of function ‘memmem’; did you mean ‘memset’? [-Werror=implicit-function-declaration]

I was confused why you and Song were having compile issues when I
wasn't.  But now I'm realizing that your incantation above

  make tools/objtool/check.o

uses the kernel's makefiles along with the kernel's compiler flags and
include directories.  And I guess it also enables a bunch more warnings
which probably explains the differences


Somehow that normally works for you?

When I try, I get

tools/objtool/check.c:6:10: fatal error: string.h: No such file or directory
    6 | #include <string.h>
      |          ^~~~~~~~~~

because of -nostdinc.


Normally I build objtool with

  make tools/objtool

or just

  make

Those use the objtool Makefile without all the extra kernel flags.

How do you normally build objtool?

Regardless, I should probably enable a lot of those extra warnings in
the objtool Makefile.

-- 
Josh

