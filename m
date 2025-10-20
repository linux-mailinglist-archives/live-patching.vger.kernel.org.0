Return-Path: <live-patching+bounces-1777-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46E27BF3748
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 22:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD2781895B8B
	for <lists+live-patching@lfdr.de>; Mon, 20 Oct 2025 20:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99AF2D0617;
	Mon, 20 Oct 2025 20:31:40 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3FE29ACE5
	for <live-patching@vger.kernel.org>; Mon, 20 Oct 2025 20:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760992300; cv=none; b=UkbQHzKLnDDsxCMv8EGeqr51DpmLh3wFLveH87QLj2cHuBLlg/CpmTaBerpUYwUzdyEiz5gOe07LibLuKlwDpMjpDZRZu6ToGKYvVXESwr9EHOtFt/j6AnjmjxHhUztMHjT2laJ9fsx1kVsRTJH+Ayri+Ya1zaAHqcbVu10odtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760992300; c=relaxed/simple;
	bh=kwQ5mRWhqn3KwbVVEu6HMiVDjmpj/6heHOhp0mrszhI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WArcaK3uIs1/mfElokUiMfRSBwBJ2qH3+0iq5uIhyPGhukloCk9MXfuXANbbhiAYo+BMFo8Ejf5GGWOgMMLEz320lXYNw9bk+KbHYZy3b5tbWVKisqaR6huel1CXRMSADCB1GBfgTuXyrS8hzlGRThrg0oZv1zMwoM7b3VWP8EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42E77853B6;
	Mon, 20 Oct 2025 20:31:31 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id 565EC2002A;
	Mon, 20 Oct 2025 20:31:29 +0000 (UTC)
Date: Mon, 20 Oct 2025 16:31:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Song Liu <song@kernel.org>
Cc: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, Petr Mladek
 <pmladek@suse.com>, "kernel-team@lists.ubuntu.com"
 <kernel-team@lists.ubuntu.com>, "live-patching@vger.kernel.org"
 <live-patching@vger.kernel.org>
Subject: Re: [External] Re: Question - Livepatch/Kprobe Coexistence on
 Ftrace-enabled Functions (Ubuntu kernel based on Linux stable 5.15.30)
Message-ID: <20251020163149.1d7f2692@gandalf.local.home>
In-Reply-To: <CAHzjS_tuotYQQ0HmncVp=oFOfcyxmYqCds0MDBMOr5FC5KzhSA@mail.gmail.com>
References: <c5058315a39d4615b333e485893345be@crowdstrike.com>
	<aO-LMaY-os44cEJP@pathway.suse.cz>
	<eb176565-6e13-4f98-8c9a-cacf7fc42f3a@crowdstrike.com>
	<aPDPYIA4_mpo-OZS@pathway.suse.cz>
	<CAHzjS_v2HfpH1Oof3BWawN51WVM_1V1uXro4MSC=0YmMiqVWcg@mail.gmail.com>
	<82eaaada-f3fc-44f7-826d-8de47ce9fd39@crowdstrike.com>
	<CAHzjS_s2RhM3_H9CCedud3zkGUWW2xkmvxvPLR1qujLZRhgL1A@mail.gmail.com>
	<CAHzjS_sQQaTZpxC2drGx8=7zCMAKQN_CNjYFcNzxZEGhd+yXPA@mail.gmail.com>
	<69339fb8-04a6-4c28-bb71-d9522ebd7282@crowdstrike.com>
	<CAHzjS_tf0KeBnzA6psjHSCuiXn--hK=owDPhCPUB0=jnLDBk=A@mail.gmail.com>
	<4cc825e6-fdf8-4fc1-8ccd-9bad456c2131@crowdstrike.com>
	<CAHzjS_soRQwKKP24DObNKBnOtiNsVZHOM-NnY_34w5GwGhC9rw@mail.gmail.com>
	<5477a73a-1dce-4b9e-b389-e757ef5536c4@crowdstrike.com>
	<CAHzjS_tuotYQQ0HmncVp=oFOfcyxmYqCds0MDBMOr5FC5KzhSA@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z9t1p3746jddjsga5ngo9w56zhq8et7m
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 565EC2002A
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+bPIGG/By3oBOFJ1S0YOEGkGDw9NXqvOU=
X-HE-Tag: 1760992289-710706
X-HE-Meta: U2FsdGVkX19g0F7DSMC5QPZGOwHnpTa/7TSN2nbSeBoj3fegMi4+vHLWb2qb2in8emz0SLFYgs5aGdiYuX036cS0nuXCt+PuEX4vnE5UEd9XbEojcxrzpok+mF4xJikCAlHdJkw22b5+htRSdn3smiyfXsBl9zfTX5yFhdlVrqfFkguCN+emUg9j6HgQ/cLsDPs09yiQJVn4SGcMJV+fntLYNeN7sqD9ifCVWlQToW5R71Jg5u6MeNS295zLvijiDfTBzdbh77WIj2OX6XQG5jwT9X/9ynBhCUpfcY24YFEks9VbzfDo5l2X7CbJ2Feyu4HRqslmKp9vIjtX9EiT32oDVxIHubcimnaaI1aD6zI35+eZx6utlQ==

On Mon, 20 Oct 2025 11:53:34 -0700
Song Liu <song@kernel.org> wrote:

> diff --git i/kernel/trace/ftrace.c w/kernel/trace/ftrace.c
> index 42bd2ba68a82..8f320df0ac52 100644
> --- i/kernel/trace/ftrace.c
> +++ w/kernel/trace/ftrace.c
> @@ -6049,6 +6049,9 @@ int register_ftrace_direct(struct ftrace_ops
> *ops, unsigned long addr)
> 
>         err = register_ftrace_function_nolock(ops);
> 
> +       if (err)
> +               remove_direct_functions_hash(hash, addr);
> +
>   out_unlock:
>         mutex_unlock(&direct_mutex);
> 
> 
> Steven,
> 
> Does this change look good to you?

With the small nit that you don't need a space between the err = and the if (err).

But yeah, looks fine to me.

-- Steve

