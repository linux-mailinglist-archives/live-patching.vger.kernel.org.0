Return-Path: <live-patching+bounces-1827-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 221D7C11AD6
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 23:25:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C038B400D7D
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 22:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910A9326D57;
	Mon, 27 Oct 2025 22:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nA/MqK24"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6781925F7B9;
	Mon, 27 Oct 2025 22:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761603751; cv=none; b=t8UszH5i0TqM+4+ATmNhzwrtpiY5i+FCJpRwc/DjCNTHwUt2aafVrdr4QhDomHIkkZTznDa7+aOCaTyx7L+m0tWF0QhaQLQd/NGNdgm6OZDJCZMe19yKr+3SQuNM9o93YwZHt+4RhHBeq+v3EF7aXBaAIDnqiTqSYUEBfCFuidc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761603751; c=relaxed/simple;
	bh=WzcYbo984hVH2IxD77QcvHr4Djfe8H3bMUqVa5YOGtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SnMdWl+TI9nAxybuXSESO0EXFUWFYNJgLd3c61YKc06vcPs9DMN6z5Xtkyg11465mu7pyMbacquPfvje05vAVHcINe5UlF4OMkRFr8QJ4Fm1qLI2Qdq2FmvMMJiTiaHMipg/YJIO6SlHeYMEa6VaedteNNzZ+/QONDSSPk/s++A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nA/MqK24; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E10C4CEF1;
	Mon, 27 Oct 2025 22:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761603750;
	bh=WzcYbo984hVH2IxD77QcvHr4Djfe8H3bMUqVa5YOGtM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nA/MqK24j5asByktAZbYpWATRsFhwk3bNCS7t8MpQdXV0hUBwbfq/eUBv5IGVGcoV
	 QDBdt1vHbMk9w7kf2qjIJCA8EABdpqTD1QsTNpgsJ6wWHwL/RL8srjzE/GPglvVS45
	 IIhRFQsjTV6nujpdRg7vK5gQoHzPp7xFBxwfhn4NlT4O8HBMiH7AkVLZ3ySeEuvnYy
	 VaUOUeEnvPo0MpmPbT0w51WiiwpQ2LfiGdrUMTnnqPtYgt0Fr+RPc0qPvwc4B2Kg7F
	 JyxX4Cto5EjWYgEeumI4h2oK6hrUPV80hnu/xlFYPNvAwS8imHxC91dFWmkbwiB1zP
	 HC+IgZmtmvjpg==
Date: Mon, 27 Oct 2025 15:22:28 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Michael Kelley <mhklinux@outlook.com>
Cc: "x86@kernel.org" <x86@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>, 
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate
 per-function checksums
Message-ID: <5an6r3jzuifkm2b7scmxv4u3suygr77apgue6zneelowbqyjzr@5g6mbczbyk5e>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
 <SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com>

On Mon, Oct 27, 2025 at 01:19:10AM +0000, Michael Kelley wrote:
> It turns out that Ubuntu 20.04 installed the 0.7.3-1 version of libxxhash. But from a
> quick look at the README on the xxhash github site, XXH3 is first supported by the
> 0.8.0 version, so the compile error probably makes sense. I found a PPA that offers
> the 0.8.3 version of xxhash for Ubuntu 20.04, and that solved the problem.
> 
> So the Makefile steps above that figure out if xxhash is present probably aren't
> sufficient, as the version of xxhash matters. And the "--checksum not supported"
> error message should be more specific about the required version.
> 
> I reproduced the behavior on two different Ubuntu 20.04 systems, but
> someone who knows this xxhash stuff better than I do should confirm
> my conclusions. Maybe the way to fix the check for the presence of xxhash is
> to augment the inline test program to include a reference to XXH3_state, but
> I haven't tried to put together a patch to do that, pending any further discussion
> or ideas.

Thanks for reporting that.  I suppose something like the below would work?

Though, maybe the missing xxhash shouldn't fail the build at all.  It's
really only needed for people who are actually trying to run klp-build.
I may look at improving that.

diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 48928c9bebef1..8b95166b31602 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -12,7 +12,7 @@ ifeq ($(SRCARCH),loongarch)
 endif
 
 ifeq ($(ARCH_HAS_KLP),y)
-	HAVE_XXHASH = $(shell echo "int main() {}" | \
+	HAVE_XXHASH = $(shell echo -e "#include <xxhash.h>\nXXH3_state_t *state;int main() {}" | \
 		      $(HOSTCC) -xc - -o /dev/null -lxxhash 2> /dev/null && echo y || echo n)
 	ifeq ($(HAVE_XXHASH),y)
 		BUILD_KLP	 := y
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 1e1ea8396eb3a..aab7fa9c7e00a 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -164,7 +164,7 @@ static bool opts_valid(void)
 
 #ifndef BUILD_KLP
 	if (opts.checksum) {
-		ERROR("--checksum not supported; install xxhash-devel/libxxhash-dev and recompile");
+		ERROR("--checksum not supported; install xxhash-devel/libxxhash-dev (version >= 0.8) and recompile");
 		return false;
 	}
 #endif

