Return-Path: <live-patching+bounces-731-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9424E999B7F
	for <lists+live-patching@lfdr.de>; Fri, 11 Oct 2024 06:09:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 868831C219DE
	for <lists+live-patching@lfdr.de>; Fri, 11 Oct 2024 04:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD2C1F4735;
	Fri, 11 Oct 2024 04:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SK7S9mY8"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876B12FB2;
	Fri, 11 Oct 2024 04:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728619758; cv=none; b=aIzsXqvq90HdY2bdyYNssSU21qMOEAktB117ZEwee70unFd7STHwOzho7oHkidbIwB+r6rxI6qvzgyt+PsgG3zvQ7mC1GYN+UGa7JCfSr3M9hzKOoImTcsvb5cLpSJqejh3TOWd7X0CPkuKIgEgER24wdOHf+ByE1KQLhJ1eaD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728619758; c=relaxed/simple;
	bh=3vXjXMO+mA49y1smb4dhyFaxOaicwtib0MRnqvTRtFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pKXcoiXQ7/60q1ih/+s1RwEBciFRQADT66vouEnEf92UIbdB0cuODWImgjrXX53Q4zeTQU2HvjkphCZecduSFiJ7aaAvfzc2KY9DTpX5JuAxZAcJ8Y9HmxXlFIUQ3S//ypTlPDEu7KCS6gBgHLFjCOli9+DFv1qlKoHTTY87Hxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SK7S9mY8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960DBC4CEC3;
	Fri, 11 Oct 2024 04:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728619758;
	bh=3vXjXMO+mA49y1smb4dhyFaxOaicwtib0MRnqvTRtFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SK7S9mY8tbJzblRl55QrXRgykTdvnrSMRVmxudvSt/Q/QrLEo24ncpIqnBC2rQu4k
	 yx9+BQmABF0gHp88RqdZO7QEKJmgdCaGjgWp4AukWgslcx6fBxhOY17rMjND8Q3S42
	 B/SaBUxTgMgmoOeJq5XTwRyOfLenQmYnu+le4iXpIiPt6VLcRVDiZceZF6T4IrZyrB
	 UdCsIhgvZtn9BLz+lSS9HOxUeigWuFItxQWTwVR2fDAAFBuMtJPy4PwkwVTojAe7Nz
	 iHNONNh6gmi9skVS9teVSwxVrPkzWrh1umqT3WTw7viwpS4fRDDwmbdVyfcO6xj9XW
	 tmG62fpjruNQA==
Date: Thu, 10 Oct 2024 21:09:15 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: zhang warden <zhangwarden@gmail.com>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>,
	Miroslav Benes <mbenes@suse.cz>, Jiri Kosina <jikos@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] selftests: livepatch: add test cases of stack_order
 sysfs interface
Message-ID: <20241011040915.bgajpxejote3jarj@treble>
References: <20241008075203.36235-1-zhangwarden@gmail.com>
 <20241008075203.36235-2-zhangwarden@gmail.com>
 <0d554ea7bd3f672d80a2566f9cbe15a151372c32.camel@suse.com>
 <A35F0A92-8901-470C-8CDF-85DE89D2597F@gmail.com>
 <20241010155116.cuata6eg3lb7usvd@treble.attlocal.net>
 <CDB9AA87-5034-40BB-891B-CC846D7EEBDA@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CDB9AA87-5034-40BB-891B-CC846D7EEBDA@gmail.com>

On Fri, Oct 11, 2024 at 09:51:07AM +0800, zhang warden wrote:
> 
> 
> > On Oct 10, 2024, at 23:51, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > 
> > Maybe add a replace=[true|false] module parameter.
> > 
> 
> How to do it? 
> Isn't the way we build modules using make?
> How to set this replace value?

See for example what
  
  tools/testing/selftests/livepatch/test_modules/test_klp_atomic_replace.c

is already doing with its "replace" parameter.  Just add replace=0 to
the insmod args to disable replace mode.

-- 
Josh

