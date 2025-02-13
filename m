Return-Path: <live-patching+bounces-1182-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE296A34C04
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 18:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0F8416A41B
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 17:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E91C23F42D;
	Thu, 13 Feb 2025 17:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OlbtKuVz"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382CD23A9AC
	for <live-patching@vger.kernel.org>; Thu, 13 Feb 2025 17:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739467976; cv=none; b=nyDJBMrQrAc2IzDuIP3XWysi45SmNT0O3Hbo+e6gkJpOUlKngMi4pqsEjoZGoNvHXR4Kn7wN7xpqjYQOeyHWlHduKk8X/VKzpotgj9BYGYmem+X+Nl6clZJ2F3TLUewriprHDsDhZ2MLu1WQ81ygXsr3D+ocxmJp17eXv21o4DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739467976; c=relaxed/simple;
	bh=gd5QtCtvAEp1W60+sobsFyKrmTTTPST5JrcfQA/DO68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fcK235+keEHEoX1d3eQL6EEvhIiMfHKD7j9eCpTsIj1S83q6Rm4qpVgbbFdxzGwHX04ucEIJujwBMrrkTKs0rMdpMdxVLza6utH+1gyEwENr/JnZHiCPb3yH75PKyti2ct1NJyqoK0nSJH2SyqamU8X0bVi00fPhWYIbGqfkjOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OlbtKuVz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602D2C4CED1;
	Thu, 13 Feb 2025 17:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739467975;
	bh=gd5QtCtvAEp1W60+sobsFyKrmTTTPST5JrcfQA/DO68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OlbtKuVzjpAHDtsOndlYhF1hYivfK9E2wQ8AoVM2Z5UTnJVVJNYy4hmk+9t7TsrI5
	 /p7z9KwI4qgRcM9xOq1LS+o9lZjx4iXSNvr+OE8Pn72C4IGbBBC8kHEUz6G4HpTa0O
	 zA2b0VdhTTqf/lNkZK64aOLNEDtetrG+ObBZ3xmr2nM02J0RfwC0ztE4mkSajpyoPC
	 S+8N7CiC/LERkBR3h1Ul1OORO4AYRHst9i809UrR/dQXBotzc1VF/S6P+Ti4mw+vAl
	 0lOfzrIfsqLuVL0xu9Rxu0q4XbgB+a2qoAn5hUQtYJl/4G7rmhALXaGa0lqKwcPQRD
	 IiVC/qPWM7nog==
Date: Thu, 13 Feb 2025 09:32:53 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: [PATCH 2/3] livepatch: Avoid blocking tasklist_lock too long
Message-ID: <20250213173253.ovivhuq2c5rmvkhj@jpoimboe>
References: <20250211062437.46811-1-laoar.shao@gmail.com>
 <20250211062437.46811-3-laoar.shao@gmail.com>
 <20250212004009.ijs4bdbn6h55p7xd@jpoimboe>
 <CALOAHbDsSsMzuOaHX2ZzgD3bJTPgMEp1E_S=vERHaTV11KrVJQ@mail.gmail.com>
 <CALOAHbDEBqZyDvSSv+KTFVR3owkjfawCQ-fT9pC1fMHNGPnG+g@mail.gmail.com>
 <Z6zBb9GRkFC-R0RE@pathway.suse.cz>
 <20250213013603.i6uxtjvc3qxlsqwc@jpoimboe>
 <Z62_6wDP894cAttk@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z62_6wDP894cAttk@pathway.suse.cz>

On Thu, Feb 13, 2025 at 10:48:27AM +0100, Petr Mladek wrote:
> On Wed 2025-02-12 17:36:03, Josh Poimboeuf wrote:
> > Or, we could do something completely different.  There's no need for
> > klp_copy_process() to copy the parent's state: a newly forked task can
> > be patched immediately because it has no stack.
> 
> Is this true, please?
> 
> If I get it correctly then copy_process() is used also by fork(2) where
> the child continues from fork(2) call. I can't find it in the code
> but I suppose that the child should use a copy of the parent's stack
> in this case.

The child's *user* stack is a copy, but the kernel stack is empty.

On x86, before adding it to the task list, copy->process() ->
copy_thread() sets the child's kernel stack pointer to empty (pointing
to 'struct inactive_task_frame' adjacent to user pt_regs) and sets the
saved instruction pointer (frame->ret_addr) to 'ret_from_fork_asm'.

Then later when the child first gets scheduled, __switch_to_asm()
switches to the new stack and pops most of the inactive_task_frame,
except for the 'ret_from_fork_asm' return value which remains on the top
of the stack.  Then it jumps to __switch_to() which then "returns" to
ret_from_fork_asm().

-- 
Josh

