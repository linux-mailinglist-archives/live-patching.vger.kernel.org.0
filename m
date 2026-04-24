Return-Path: <live-patching+bounces-2522-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yG4fDjHZ62nRSAAAu9opvQ
	(envelope-from <live-patching+bounces-2522-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:57:21 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 73C084635B7
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 878E8300C922
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 20:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F843FBEA5;
	Fri, 24 Apr 2026 20:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PBd3ZWMG"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B5937C92A
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 20:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777064237; cv=none; b=abUeYn2chwjGQ3TQzyMj0Np5PGzySdpZE5ERvozJpYXAneA/m9s+dq8eRrQMAV6QfGsg9FBsb0mhsfhMNUpK++Lo0NMZIbBFQJVsbLhye0tpHCWaD+J8SGQ+OgW5QSQf4O5vNgNFUdbMg2/l59wzxaeyNyYuPq3tibh73Rp6dSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777064237; c=relaxed/simple;
	bh=mrkbGoHpjSvpZNJO2/5akwLGIK5BPtm3sUR2/3lOA/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VsBjq9pF9nltR0c3HLglGHY/CcdlhTreuHnIQar36qcHdDAXSixIn0WKocKU5sdhP2I+Q3neAbU3xIi7LG8fMRwTNwTg7MFsgb5QzC9KYUTCNP3WSlkH/eXM/4UaxW2WVURU9ooQDoJtJg8gotwlTE5gb2YRFnABj5gx2QMj+pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PBd3ZWMG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60BBC2BCB4
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 20:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777064237;
	bh=mrkbGoHpjSvpZNJO2/5akwLGIK5BPtm3sUR2/3lOA/8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PBd3ZWMGR/rmn/wKM75UybPVZ4MJMrOMACk1pTSNfGk8ooweZ/opaGUzcuKK3iQEL
	 YxmWybauwUFWz36XI5hKNdeT2lda7Col63DFs2ed/nDZG4qJXI8/XGKts+izQLaGy6
	 Etnu1Sv1C/Ce1r/puxal3t6FFg1g2uyl4uKwGtDg3tSqnJ3r/b6CnZJo3D5WvOh966
	 Q1OD0/jhv6rvAEmZAHg1fot11cg3kvnsbPSb7pMxuMnaJyO451/unDjfG9MFuPeDDY
	 6Xgw5sIA0zEVqYf3Kh6xEncgszESu5yCvULoOA2AoYWrZzidtSALuIjd3MyrvD4o8k
	 NLtJbyCBa+pgQ==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8a210c813f8so55745116d6.0
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 13:57:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9CMlMvh0dID+UlckVO3GJ0HTbJdb8mPdlVmup2bnMYLefpWgctOaPT6IM8WoaRjTacKFCtA1GU0sPfLGLZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yyo80YQmJGgX8LjdLkKqOZKhmpKt7bL/x6HsfgStxD/liPuAz82
	SeomRzx5II6PRH+DfDVLPo3QohiHOa2M+JPYmAhj0wDAFkEnx4dcwR6PbRxLlNyY/SWediDpLtM
	bLDJX7VuG9d+lSfgux0Sd4rrJM8j57Pk=
X-Received: by 2002:a05:6214:4f18:b0:8a0:d08c:a721 with SMTP id
 6a1803df08f44-8b0280a470bmr460532056d6.22.1777064236858; Fri, 24 Apr 2026
 13:57:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <b62dafa3c40576c8e82b062bc24116772c272b87.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <b62dafa3c40576c8e82b062bc24116772c272b87.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 13:57:05 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6PNH+uEe5K54q5R9JazHZm+HBWpyhLeqax3WSYLYGrww@mail.gmail.com>
X-Gm-Features: AQROBzDDU9kCeYkEEiY2XxGsFUt3kgckMKgHQ3FRqLcJ-uYS9ojdSF01-5KcVr4
Message-ID: <CAPhsuW6PNH+uEe5K54q5R9JazHZm+HBWpyhLeqax3WSYLYGrww@mail.gmail.com>
Subject: Re: [PATCH 08/48] objtool/klp: Don't correlate __initstub__ symbols
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 73C084635B7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2522-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> With LTO, the initcall infrastructure generates __initstub__kmod_*
> wrapper functions in .init.text.  These are the LTO equivalent of
> __initcall__kmod_* data pointers, which are already excluded from
> correlation.
>
> These are __init functions whose memory is freed after boot, so there's
> no reason to include or reference them in a livepatch module.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

