Return-Path: <live-patching+bounces-578-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A386096AFCF
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 06:30:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D66541C2338D
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 04:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8087C823AC;
	Wed,  4 Sep 2024 04:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="acoIfdSe"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5709681AB6;
	Wed,  4 Sep 2024 04:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725424237; cv=none; b=iIF3kg+9gF5kuvSZv32VIwhEvY5RjkKP+bPcOTiLl91sZnfSAUk7dtK1QHMyd0JsV3GvP2j0Cq1wgzQMEHHj6zrneSmtHWKlzIv1r7LCC/3UdQtTuN6dJxpQhXf+9Xdx6Gev9BZgEnkPJ95hcWBVUWm4a9vrandD07cIPWHuoTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725424237; c=relaxed/simple;
	bh=MAdzDHHKtXun7pzXRpyY+whxZK66qwaWKm5RCmmf9iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MiwapvaUO0PMp4PaZ1gAY1giFl5zIwCmF34SXYWW5Ief/knOUu8Q8bzIbCK7cgJroVrfGw0hCO83jtrNoHvXd9sfApDwCcWhUAqoLyvcGKTIT0qr4VvVdiCw6v+JvBAePvz/YSeJzk7jstRTsrQ2tLacIDRACq5pzQt/D3BBGYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=acoIfdSe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7859AC4CEC8;
	Wed,  4 Sep 2024 04:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725424236;
	bh=MAdzDHHKtXun7pzXRpyY+whxZK66qwaWKm5RCmmf9iE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=acoIfdSefqKxpBdky4UF5QEJG8BX97O2KdOLzq7slD3TrSOE3QRGZeAjxIa41hBXH
	 +dOfbbKjDn88tJAclJ8MS6F/hW7BCJR/XktIE/vWlOLOwFobbXuYtQZYWM5p8CRuqB
	 M68C7z1K++EGK7qM3X9U4dOGXrxpl8W5gIGWjO9IK4sZ+nrYnpx1t/+r6P0NhvLIjZ
	 zeK0/sCOBdqdMipveX5RJe8uC7jn1B5RU6bVgu/sRAB2zKYMaU+RyLhDo8cgL+u3pJ
	 Z9jlvX42slG922Ck8Y2cTnZIHoPlVXAP3n0FMtSl+SOpT92NsileTrP/uC6vSS/0Ei
	 C+faS2uJ86JHw==
Date: Tue, 3 Sep 2024 21:30:34 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <20240904043034.jwy4v2y4wkinjqe4@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>

On Tue, Sep 03, 2024 at 10:32:00AM -0700, Song Liu wrote:
> Hi Josh,
> 
> Thanks for the patchset! We really need this work so that we can undo our
> hack for LTO enabled kernels.
> 
> On Mon, Sep 2, 2024 at 9:00 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > Hi,
> >
> > Here's a new way to build livepatch modules called klp-build.
> >
> > I started working on it when I realized that objtool already does 99% of
> > the work needed for detecting function changes.
> >
> > This is similar in concept to kpatch-build, but the implementation is
> > much cleaner.
> >
> > Personally I still have reservations about the "source-based" approach
> > (klp-convert and friends), including the fragility and performance
> > concerns of -flive-patching.  I would submit that klp-build might be
> > considered the "official" way to make livepatch modules.
> >
> > Please try it out and let me know what you think.  Based on v6.10.
> >
> > Also avaiable at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-rfc
> 
> I tried to compile the code in this branch with gcc-12 and llvm-18. Some
> of these errors are easy to fix (attached below). But some are trickier, for
> example:
> 
> with gcc-12:
>   ...
>   BTFIDS  vmlinux
>   NM      System.map
>   SORTTAB vmlinux
> incomplete ORC unwind tables in file: vmlinux
> Failed to sort kernel tables

Thanks for trying it!  If you share your config(s) I can look into it.

I haven't tried clang yet, but will soon.

-- 
Josh

