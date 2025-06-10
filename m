Return-Path: <live-patching+bounces-1513-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D3F3AD43AF
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 22:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9D89189DAF8
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 20:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3678264A77;
	Tue, 10 Jun 2025 20:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSlAbSNl"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD5A2343C9;
	Tue, 10 Jun 2025 20:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749587166; cv=none; b=r7OOG8nQl7e2R0X0NGU/pw4hLpciXHykBwJRzj/GSExxXrC0+6+u3EgnVfHIbheaiVoTKPw8PeEj0i0ot4F1pWpcV6+vLA7mlOxjG4r7xyH99XgYtOHRU5hmKgKyXSeVe9PLOJPltK6Tos27j3kMSGx6FmF1fRYl9lTa4tV/Ta0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749587166; c=relaxed/simple;
	bh=i3xUcE4fdZGKDOP58lBw3BpW2oKS2ltdgZiiQYUta/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9tE2rXWL8s0c+eY5vcYuFk/167shZUToTRvjTCT14rFIKl7GbXBo/arlVE4BFWEl9pfGsBE4vTRCV7po6BwRLz6y5O6aqK3veFqUSXfyG0rVZZlJuY70CFXep2sLxuTPvCuzJG0JFm82Zq6vw1UNKpMYWnhnXSxalqU/JEkIkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eSlAbSNl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090E0C4CEED;
	Tue, 10 Jun 2025 20:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749587166;
	bh=i3xUcE4fdZGKDOP58lBw3BpW2oKS2ltdgZiiQYUta/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eSlAbSNldfQPts2zj2j6xQv5+cZ6micM6ApZDx5b0Bu9c+h3MYT35UCGFDrpaOsFp
	 +a529eXBgUMkaKqnZB2ADouOGsrM1Up3xonjSzDyF3FwEbHjnADlDcuXK5lXiPDG91
	 BGZSF/lS2ZWh3K5wkHWrhr315jlrla+9WS6pv85xLBI/RaxJUE1fFxaFKgyjd3KN2G
	 cVE5q/rdIe1eyWkGt7J+dpg8XoPG88J7CotMnvQD8a6SvEjiWBJKgsPyaOzmxhW7OW
	 Xm6EVmAKBWB4B5K/eTgcu2KJLxauV56fsnjhAhq+ooBaBNXvfBtMQXz8OQmCdu7waS
	 Zj7HJHwe7fg1A==
Date: Tue, 10 Jun 2025 13:26:03 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <6bzrbh6sotmdh2426iky6s74yqfwiiooe5k3wif72pdvrpi322@23gntwfq7n7z>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
 <aEcos4fig5KVDQSp@redhat.com>
 <2oublab5wrfzneispi4sqb6feiw2abc3mzxozmx53btuvseljh@3qsmyluomyir>
 <6f93bb5c-43da-4a88-a8b3-7b7ea992b0e6@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6f93bb5c-43da-4a88-a8b3-7b7ea992b0e6@redhat.com>

On Tue, Jun 10, 2025 at 08:39:10AM -0400, Joe Lawrence wrote:
> >> Should we check for other data section prefixes here, like:
> >>
> >> 			else {
> >> 				snprintf(sec_name, SEC_NAME_LEN, ".rodata.%s", sym->name);
> >> 				if (!strcmp(sym->sec->name, sec_name))
> >> 					found_data = true;
> >> 			}
> > 
> > Indeed.  And also .bss.*.
> > 
> >> At the same time, while we're here, what about other .text.* section
> >> prefixes?
> > 
> > AFAIK, .text.* is the only one.
> > 
> 
> What about .text.unlikely, .text.hot (not sure if these can come alone
> or are only optimization copies) ?

Hm, I think .text.unlikely.foo is at least theoretically possible
without .text.foo.  Seems "unlikely" though.

IIRC, .text.hot is used for profile-guided optimization, probably not a
concern here.

There are actually several edge cases that would cause this validation
to fail.  If a module only had init/exit then it wouldn't have any
.text.foo.  Or if it didn't have global data then there'd be no
.[ro]data.foo.

This function could get pretty fiddly, and honestly I'm not sure this
validation buys us much anyway.  I'm thinking about just removing it
altogether...

-- 
Josh

