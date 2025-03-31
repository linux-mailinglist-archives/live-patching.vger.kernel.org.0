Return-Path: <live-patching+bounces-1349-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABEE5A76766
	for <lists+live-patching@lfdr.de>; Mon, 31 Mar 2025 16:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8F4E7A2D44
	for <lists+live-patching@lfdr.de>; Mon, 31 Mar 2025 14:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F3F2135AD;
	Mon, 31 Mar 2025 14:08:45 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C667A3234;
	Mon, 31 Mar 2025 14:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743430125; cv=none; b=QOAEgpHA5Fc4BxrXrPz8Eezx5jvhW3aQxhras0xYdHgwubP6ij6vZDzKywJ6OX1Z7X/hcYHBXcJZkFdzr7zIXfnyRNlyh2mROOPlVVnh5bXGU2Chjh4w8k9v0Ks2jpI47GfWLsyVCraUFl8hIBnHTVFvQJfJ2XtvLRONjYXrVbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743430125; c=relaxed/simple;
	bh=PToFCzKfDCXNFnIrJqTIZCDzDC0JavZmtnFBn7bZiJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VjPPcnJm+7UDN9brkiM74vzMJbLri3j09yggDBGBY8iUVnayyZZS4Bc2ZzW3dCEFAYiVgdNs6naZ1DHHocQuyA7ExtTSMHVzbQlNL+JUDBBYtwskyfsGjQh2Y4KWFfSERBcqaOCG8clT38GS+/mkY0ywLltlGbM7E00S8pZhHnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E1BC4CEE3;
	Mon, 31 Mar 2025 14:08:42 +0000 (UTC)
Date: Mon, 31 Mar 2025 10:09:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc: "Naveen N. Rao" <naveen@kernel.org>, Hari Bathini
 <hbathini@linux.ibm.com>, bpf@vger.kernel.org, Michael Ellerman
 <mpe@ellerman.id.au>, Mark Rutland <mark.rutland@arm.com>, Daniel Borkmann
 <daniel@iogearbox.net>, Masahiro Yamada <masahiroy@kernel.org>, Nicholas
 Piggin <npiggin@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Vishal Chourasia
 <vishalc@linux.ibm.com>, Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
 Miroslav Benes <mbenes@suse.cz>, Michal =?UTF-8?B?U3VjaMOhbmVr?=
 <msuchanek@suse.de>, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
 live-patching@vger.kernel.org
Subject: Re: [BUG?] ppc64le: fentry BPF not triggered after live patch
 (v6.14)
Message-ID: <20250331100940.3dc5e23a@gandalf.local.home>
In-Reply-To: <rwmwrvvtg3pd7qrnt3of6dideioohwhsplancoc2gdrjran7bg@j5tqng6loymr>
References: <rwmwrvvtg3pd7qrnt3of6dideioohwhsplancoc2gdrjran7bg@j5tqng6loymr>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 31 Mar 2025 21:19:36 +0800
Shung-Hsi Yu <shung-hsi.yu@suse.com> wrote:

> Hi all,
> 
> On ppc64le (v6.14, kernel config attached), I've observed that fentry
> BPF programs stop being invoked after the target kernel function is live
> patched. This occurs regardless of whether the BPF program was attached
> before or after the live patch. I believe fentry/fprobe on ppc64le is
> added with [1].
> 
> Steps to reproduce on ppc64le:
> - Use bpftrace (v0.10.0+) to attach a BPF program to cmdline_proc_show
>   with fentry (kfunc is the older name bpftrace used for fentry, used
>   here for max compatability)
> 
>     bpftrace -e 'kfunc:cmdline_proc_show { printf("%lld: cmdline_proc_show() called by %s\n", nsecs(), comm) }'
> 
> - Run `cat /proc/cmdline` and observe bpftrace output
> 
> - Load samples/livepatch/livepatch-sample.ko
> 
> - Run `cat /proc/cmdline` again. Observe "this has been live patched" in
>   output, but no new bpftrace output.
> 
> Note: once the live patching module is disabled through the sysfs interface
> the BPF program invocation is restored.
> 
> Is this the expected interaction between fentry BPF and live patching?
> On x86_64 it does _not_ happen, so I'd guess the behavior on ppc64le is
> unintended. Any insights appreciated.

Hmm, I'm not sure how well BPF function attachment and live patching
interact. Can you see if on x86 the live patch is actually updated when a
BPF program is attached?

Would be even more interesting to see how BPF reading the return code works
with live patching, as it calls the function directly from the BPF
trampoline. I wonder, does it call the live patched function, or does it
call the original one?

-- Steve


> 
> 
> Thanks,
> Shung-Hsi Yu
> 
> 1: https://lore.kernel.org/all/20241030070850.1361304-2-hbathini@linux.ibm.com/


