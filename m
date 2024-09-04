Return-Path: <live-patching+bounces-583-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F4296B262
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 09:10:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4C14283AD5
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 07:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D4E13B2A4;
	Wed,  4 Sep 2024 07:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RR91OCh5"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E4A1EC01C;
	Wed,  4 Sep 2024 07:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725433794; cv=none; b=hSFmuZlMx6CbZbCxz32H98lwSIZp6pYERSl8xs7lXCsj85fiICn1hfOoEm1GZMWiGkJlYyx0cYriAdffIKESLe5iBGRNrGo+YTPFAmjaNXP00955jSVZbt3Bz3X5206eDs8QF++QTFjT4C6KC4HLJZxZ45U6nxoiGU96MvVjAkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725433794; c=relaxed/simple;
	bh=T5l6QLHUy29hq1aXr7kOmqiti/fIWBIR5NvAWbdKGNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=td2fZFp5rotyoMrKbxakz+vdMNPWP4Q+KQpAx7PswdXWqJYyrJNTJxlNYrUN5QXmwX/2aF2tHC+iGYUZ83ajTFELOJ5t3c2CBIi0OqhuEeNw3PkhMS28opUfTJ0IkkcSwmznSd7rww5Dupia6hzMBs72Vs9bfECPIRe2yPrlEiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RR91OCh5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27887C4CEC2;
	Wed,  4 Sep 2024 07:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725433794;
	bh=T5l6QLHUy29hq1aXr7kOmqiti/fIWBIR5NvAWbdKGNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RR91OCh55T+nyIofUoMFXT8y0GFVqjinMsl00LiCaMFqbJo36CrmscW9jWzle1ZvN
	 6TdqiIMHGODUgqYWFBXyLl/yGstDbMHmosBBs+SYyiXHXxM9VXJriW2GTvSHDrg1De
	 q/zG1QUl1JOS315/a9gu1/VEgbLwv5jhlz+PJFMJwD1ZKeaB93bB2DTRh6kInDKoT9
	 hr38sOalnQKG7+I3irZlhkDkL/tH+Y/P1wzNYeh2K4ji/niz8J4tXh+IT3zPogVeXw
	 2Jb6KhuiuLdsfN7Ns3mx0Ufj8vtvrcZ/DaoDSB2+MqkCnsJHpuEOCZcvc2LGl6Tv0p
	 07Q+7idLqn7OA==
Date: Wed, 4 Sep 2024 00:09:52 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <20240904070952.kkafz2w5m7wnhblh@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <CAPhsuW6V-Scxv0yqyxmGW7e5XHmkSsHuSCdQ2qfKVbHpqu92xg@mail.gmail.com>
 <20240904043034.jwy4v2y4wkinjqe4@treble>
 <CAPhsuW6+6S5qBGEvFfVh7M-_-FntL=Rk=OqZzvQjpZ6MyDhNuA@mail.gmail.com>
 <20240904063736.c7ru2k5o7x35o2vy@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240904063736.c7ru2k5o7x35o2vy@treble>

On Tue, Sep 03, 2024 at 11:37:39PM -0700, Josh Poimboeuf wrote:
> On Tue, Sep 03, 2024 at 10:26:02PM -0700, Song Liu wrote:
> > Hi Josh,
> > 
> > I have attached the config I used for LLVM and gcc.
> 
> !IBT is triggering the ORC bug.  This should fix it:

Also a CONFIG_MODVERSIONS fix:

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 518c70b8db50..643bfba65d48 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -60,7 +60,8 @@ vmlinux_link()
 	# skip output file argument
 	shift
 
-	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT; then
+	if is_enabled CONFIG_LTO_CLANG || is_enabled CONFIG_X86_KERNEL_IBT ||
+	   is_enabled CONFIG_LIVEPATCH; then
 		# Use vmlinux.o instead of performing the slow LTO link again.
 		objs=vmlinux.o
 		libs=
diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index e16584a4b697..385acb955861 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -234,6 +234,10 @@ diff_objects() {
 		# status "diff: $rel_file"
 
 		"$SRC/tools/objtool/objtool" klp diff "$orig" "$patched" "$output" || die "objtool klp diff failed"
+
+		if [[ $(basename "$output") = "vmlinux.o" ]] && [[ -e .vmlinux.o.cmd ]]; then
+			cp -f .vmlinux.o.cmd "$OUTPUT_DIR"
+		fi
 	done < <(find "$BUILD_DIR" -type f \( -name vmlinux.o -o -name "*.ko" \) -newer "$timestamp")
 
 	local nr_objs="$(find "$OUTPUT_DIR" -type f \( -name vmlinux.o -o -name "*.ko" \) | wc -l)"

