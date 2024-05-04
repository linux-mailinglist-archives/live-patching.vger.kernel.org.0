Return-Path: <live-patching+bounces-234-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 925AF8BBEBA
	for <lists+live-patching@lfdr.de>; Sun,  5 May 2024 00:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3447F281D12
	for <lists+live-patching@lfdr.de>; Sat,  4 May 2024 22:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6A7784DF5;
	Sat,  4 May 2024 22:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cD21wkrt"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B35284A39;
	Sat,  4 May 2024 22:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714861621; cv=none; b=Qqb8nTSE1aBcrtdNipN5uTnwAtCM3n+chetTCNgr2y0iPM0RnA4ovJpuN6FFOKDqoM4kmDqS/FGuCLDnqVA2ggGjpKyRYdURB4lymbzETx98ihpO1F0z7jNbFky2LleBqlBHK615TKwoYEXRoBhwDf9VOqotzgPGXWonjKL9WTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714861621; c=relaxed/simple;
	bh=uaYQblTXrpEuhYQ0zK/G61P93+TnCy6IvmKUKA9hBrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eDROffMsD4OsX3OKASQwqlsn7oJFAxohwX8+Zm5r8M6/fdRMddOpmSNOuAcrZbmpuQXxFSSoxVmWaiMrwSv4fOQXfV9BRnYU20YJoOfnhLZUqMFkOJaDB5+8suPiNcV5pQZ4A5svrmYDVlGOoLQE4nNq9wrPYg8ygeH8alrRi8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cD21wkrt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96344C072AA;
	Sat,  4 May 2024 22:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714861621;
	bh=uaYQblTXrpEuhYQ0zK/G61P93+TnCy6IvmKUKA9hBrg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cD21wkrtp4hdbTZSzXrfGG7o+lp8uLONdRPSoQzAZaoYwDtC8y81K7cV2bJ00JP3K
	 7nZel7W6knTM+8KA8nncb441WqyI9mBRn4Lf4yTZVCgASkNl+YQLmW846ZfWwjukLz
	 T1hZfINiPXvDKir52/1CjCS3jDPaqePI36pqttqzu31640Rsuopxp9E/i2S/wh4myx
	 MTqJ0/KJgY3KUXPRGCrcU6226R8aSbuVPDzQAjrLDGHpYEl8oOhRnXH0/OjYogzzE6
	 ZZHMue1hvt7ZunNT/4W/NNPfDeTdW2/czHfhbjZWoG17iOnJBeCHzTFjGjvsGZe2JR
	 Z7CeOtKqp8UxA==
Date: Sat, 4 May 2024 15:26:58 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Yafang Shao <laoar.shao@gmail.com>, jikos@kernel.org, mbenes@suse.cz,
	pmladek@suse.com, joe.lawrence@redhat.com, mcgrof@kernel.org,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 1/2] module: Add a new helper delete_module()
Message-ID: <20240504222658.xd74t2phkbhqrxp5@treble>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
 <20240407035730.20282-2-laoar.shao@gmail.com>
 <CALOAHbDGcY5y6hWZgJp9ELrt_w4pfB-X3EqS3yu8k37pj3ZEcw@mail.gmail.com>
 <2024050415-refocus-preoccupy-6d53@gregkh>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2024050415-refocus-preoccupy-6d53@gregkh>

On Sat, May 04, 2024 at 06:53:05PM +0200, Greg KH wrote:
> > Luis, Greg,
> > 
> > Since the last version, there hasn't been any response. Would you mind
> > taking a moment to review it and provide your feedback on the
> > kernel/module changes?
> 
> There was response on patch 2/2, which is why I deleted this from my
> review queue a long time ago.

Assuming you're referring to my comment (which is the only one I've
seen), that was only yesterday ;-)

> Please address that if you wish to, and then resend if you feel this is
> still needed.
> 
> Personally, I really don't like this function you added...

I tend to agree...

-- 
Josh

