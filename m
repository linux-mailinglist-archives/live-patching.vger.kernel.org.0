Return-Path: <live-patching+bounces-2411-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOgqJQH952m6DwIAu9opvQ
	(envelope-from <live-patching+bounces-2411-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:41:05 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C25544036C
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:41:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2D73830117E5
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 22:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2DC23A6412;
	Tue, 21 Apr 2026 22:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dl+2IoGH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9A139F17D
	for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 22:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776811258; cv=none; b=qr9+zVOy099S9FDBacsRyj1OFVOj65QQYjq59Vx5ZvJTxmBP80Nmyi9sZRkuVPyaPQ7vU9U6NAbQiQmegqY0IS3WWH2kj44aRc0385bzK5K9E5nclY+AqscCOaBGGD0yBw27wCw4Xu7iMjarZh/oypcSPtXwvdIpVfiDGAsa3UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776811258; c=relaxed/simple;
	bh=+8Ta7U3L4TbgcUEZFLK/HPCsnWeYOSpoEcpgWOXF5ic=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BqIjFpxMdefjZtOFsgApAB0vtPVDiT3h97Nd8kr+6vp5K+SacQhOsz9ZuBpAe3Hv3qNpUjlqdf+6Vte4X2aOldHwz5bcpbsgEF2o4NHvytIwuloB3kJ55kdDrFXYUyqq/149i3opel9MGtZA/AiLAariiXCo2I+hfnjpdH+GvXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dl+2IoGH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AFFC2BCB9
	for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 22:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776811258;
	bh=+8Ta7U3L4TbgcUEZFLK/HPCsnWeYOSpoEcpgWOXF5ic=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dl+2IoGHcD1abPM6p0ta768cK+nV2WWCgU73PSgqaFXccXH/cYV9gXqhpZEboWUeU
	 AywPOXscswc7xbP4PMlieq7wUEKXMMAFDxORoMfQ2MwWzNXsee70vIsJOnUgHGOCZA
	 ONJChqX95VHr2zTRXNIXVG+wQTvu5RwPtnvUZkSXhUqVO2uIII+VlKPqkvSP8eVA+x
	 xI0ZT6IYAOIiAiKdy6juCrNxvbQBtZXivBHmrm64V4k71OvlPu8LWL/2r0v2KsUR/x
	 h70jSFv/s4OWfpUvFWIASrwwRJ3h9LWQTte5VC6W9qzjhRXg8DbcxjOEUrRLccZKzG
	 WzKNnkTiMV1ug==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8ec9f099fc6so222600685a.0
        for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 15:40:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ91rqi9QsyfKTYkZVL+hKDTCtXg0hJIhd2RBLevJBuWl43XoeSwbsm3Ri5jk/nvhmmHOA2n5QmNGLQckxLb@vger.kernel.org
X-Gm-Message-State: AOJu0YwH+6LVOLlJzUZ1UnYQ1V8Nw9lW79zOtAWZjtsPyrs2Sk19NLkI
	2+OplnuIbzodf/WXuTm/UNOuJSru8qFoWYR8bL2IHRtFHAGQQQlaMulQi6etcC6FP/Q7dwdvmhB
	2osA/QaWweJg3s1vyCGqhwtJuK/jhpBU=
X-Received: by 2002:a05:620a:2953:b0:8cd:7952:d449 with SMTP id
 af79cd13be357-8e7918a34b8mr2892702785a.29.1776811257679; Tue, 21 Apr 2026
 15:40:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260225054639.21637-1-chensong_2000@189.cn> <20260225192724.48ed165e@fedora>
 <e18ed5f4-3917-46e7-bca9-78063e6e4457@189.cn> <alpine.LSU.2.21.2602261147150.5739@pobox.suse.cz>
 <20260226123014.2197d9b7@gandalf.local.home> <321d4670-27cb-453f-a50d-426c83894074@189.cn>
 <aaqk-GrpCTqO36xj@pathway.suse.cz> <4037aa19-1b01-4076-b823-5cc0e43becac@189.cn>
In-Reply-To: <4037aa19-1b01-4076-b823-5cc0e43becac@189.cn>
From: Song Liu <song@kernel.org>
Date: Tue, 21 Apr 2026 15:40:46 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4TkxEQAZt0ggbAO7+fm2RabTGb_vsnQ9rFXGacm3RAtw@mail.gmail.com>
X-Gm-Features: AQROBzAvMTYSV5nNLSiUr2ZDdV1n0E9WLV1CWsr3dpVAQqPMW5tLMYBS9_AZ9MQ
Message-ID: <CAPhsuW4TkxEQAZt0ggbAO7+fm2RabTGb_vsnQ9rFXGacm3RAtw@mail.gmail.com>
Subject: Re: [PATCH] kernel/trace/ftrace: introduce ftrace module notifier
To: Song Chen <chensong_2000@189.cn>
Cc: Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Miroslav Benes <mbenes@suse.cz>, mcgrof@kernel.org, petr.pavlu@suse.com, 
	da.gomez@kernel.org, samitolvanen@google.com, atomlin@atomlin.com, 
	mhiramat@kernel.org, mark.rutland@arm.com, mathieu.desnoyers@efficios.com, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2411-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[189.cn];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid,189.cn:email]
X-Rspamd-Queue-Id: 2C25544036C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

I am replying partially to make sure folks know there are two
persons with the same first name.

On Sun, Apr 12, 2026 at 7:11=E2=80=AFAM Song Chen <chensong_2000@189.cn> wr=
ote:
[...]
> >
> >    + We would need to make sure that it does not break some
> >      existing "hidden" dependencies.
> >
> Thanks so much, this is the solution i'm working on. I replaced next
> with a list_head in notifier_block and implemented
> anotifier_call_chain_reverse to address the order issues, like your
> suggestion. And a new robust revision for rolling back.

I personally don't think there is strong enough motivation to make
changes like the following. If there is indeed strong motivations,
please make it clear in the next revision.

Thanks,
Song

