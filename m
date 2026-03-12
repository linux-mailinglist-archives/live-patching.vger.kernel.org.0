Return-Path: <live-patching+bounces-2196-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MGfvHhzKsmk9PwAAu9opvQ
	(envelope-from <live-patching+bounces-2196-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 15:13:48 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3310E27324E
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 15:13:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2C25D306114A
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 14:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1962935CBD7;
	Thu, 12 Mar 2026 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tzbpDLF3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE9640DFD5;
	Thu, 12 Mar 2026 14:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773324770; cv=none; b=d+YKRKKpF6LVebijbbbx90X6KwYqzNQsObro0P+RQd8obG7VIHqugOe+3w+WwOASyvFPF/Tk4/yca/x6o4z1V8cIug7YbeNzBaB/W6q1qCMvK6nbDhwyCr7/B0JAqPA9ScLsnyHUMOhkUuzG6j045dU1EGmkJrYBfCOE0kGd4ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773324770; c=relaxed/simple;
	bh=JUNNBRHYqAlI90eVN92Ye3wzh5o69+j3AKe0pIbjTr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rltjz7MUl1GqDA4tSFecOCCVdwPJkC8Rv3FKfiyi88dSfkvg7cPB9Q6JE4utCe9RRk5gFmMOG9w2sgdELeQEeV1j+BhsWsTXlFSEwXRH757G5tlOzor/B/7PHKnatnoCldSRzzb38TMtbgIFfcx/ZubPfnfw6/Qj5hPjn7VmsA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tzbpDLF3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F339CC4CEF7;
	Thu, 12 Mar 2026 14:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773324769;
	bh=JUNNBRHYqAlI90eVN92Ye3wzh5o69+j3AKe0pIbjTr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzbpDLF352DZo8kyJ8wujuZ3MzRPcZcr3Bwhj7BTReIFDFWjwhgaep3va6mEfBXG2
	 QsTH81aXUkiRtTJ6BZM0aIpST1pDxkvw4hihtxnxGfl0cVCU02aMLA9ANc0hUqzSN4
	 PWzELtT8n6W7aFGjNuPeu6RHgViAtADqZegyW1iYRH7MCx0km7J4OcS9na/pPRvaOU
	 amd3vjGbX0QNjbxR8QZm/V8LKeTk9R7vPaLuXGBhf/nss+GJRjVgK6dTntFSkcPFDj
	 4rWvMLZ9Uw+qYDc3gRQqKLsVYBuSzhrWZaqj3wd2VS+XEzO/E/MX3k4+yThZEaeJSD
	 P41YKGCaULBzQ==
From: Nicolas Schier <nsc@kernel.org>
To: linux-kbuild@vger.kernel.org,
	live-patching@vger.kernel.org,
	Yonghong Song <yonghong.song@linux.dev>
Cc: Nicolas Schier <nsc@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	kernel-team@fb.com,
	Nathan Chancellor <nathan@kernel.org>,
	Song Liu <song@kernel.org>
Subject: Re: [PATCH kbuild v2] kbuild: Reduce the number of compiler-generated suffixes for clang thin-lto build
Date: Thu, 12 Mar 2026 15:12:24 +0100
Message-ID: <177332462174.82802.2344537821152391518.b4-ty@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260307050250.3767489-1-yonghong.song@linux.dev>
References: <20260307050250.3767489-1-yonghong.song@linux.dev>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2196-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nsc@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3310E27324E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, 06 Mar 2026 21:02:50 -0800, Yonghong Song wrote:
> The current clang thin-lto build often produces lots of symbols with
> suffix. The following is a partial list of such function call symbols:
>     ...
>     ethnl_module_fw_flash_ntf.llvm.7631589765585346066
>     __nf_conntrack_alloc.llvm.6438426151906658917
>     tcp_can_early_drop.llvm.11937612064648250727
>     tcp_print_conntrack.llvm.11937612064648250727
>     ...
> 
> [...]

Note: Due to application of [1] to kbuild-next-unstable, I had to update the
      patch context.

[1]: https://lore.kernel.org/linux-kbuild/20251028182822.3210436-1-xur@google.com/



Applied to kbuild/kbuild-next.git (kbuild-next-unstable), thanks!

[1/1] kbuild: Reduce the number of compiler-generated suffixes for clang thin-lto build
      https://git.kernel.org/kbuild/c/b7a7ce34

Please look out for regression or issue reports or other follow up
comments, as they may result in the patch/series getting dropped,
reverted or modified (e.g. trailers). Patches applied to the
kbuild-next-unstable branch are accepted pending wider testing in
linux-next and any post-commit review; they will generally be moved
to the kbuild-next branch in about a week if no issues are found.

Best regards,
-- 
Nicolas


