Return-Path: <live-patching+bounces-1512-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AC9EAD3E64
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 18:10:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 470C37A9929
	for <lists+live-patching@lfdr.de>; Tue, 10 Jun 2025 16:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50FA23C501;
	Tue, 10 Jun 2025 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLvxXhI2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB4D23A99D;
	Tue, 10 Jun 2025 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749571822; cv=none; b=rixSvqgSfBqvICiN1pzqF7fNECc2Mx2YWjnVB0ZEpEZ9zWfnIw2zRsI1LA9hyJBOboUzzCiNG7/J3fcQXnOimbzgefx1d3+bZjjmuQPO3OGXrSzwbuoEDyFFfJHUODTF87uLVzuv0kDUq43WV+NWNyrKDIvW4j/c2r/PmR8R8XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749571822; c=relaxed/simple;
	bh=SrjumL+rBGwAE+luWw3qe8CwCfGvsjehDnOPtM8IRvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nIjRZ49i8ZO0K7SfwnaN7XPNdHyNNtDfDwSqyWBEQNQPqrB4sHFkM7kOEWoGCZEneVs9IVGl1+8ZOwfToQKm9CLLKlXR6Vt5Zo2+aqDVS/FQ19S40uhq6OOicwY3qaDAJ/e29c7d4yRVAdlN/px5KkqsNpa28pqyp1oxeQlicig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLvxXhI2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738E1C4CEED;
	Tue, 10 Jun 2025 16:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749571822;
	bh=SrjumL+rBGwAE+luWw3qe8CwCfGvsjehDnOPtM8IRvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GLvxXhI2zmlx/Hr/6/tq9q6g3qvmR62oHxq76gLXdtR5ilCjw/8V3zU46Mtj6TR1h
	 vFk0saiIIDBBGGKLp3Fp4OPLnDA94ahZ6D8JY8Er95ZrIM3nJ1TI05ZPSUe9Pro3qD
	 4ncJ//lENeXJfG5x8oYyYBbY7hHzs0U4zDRO+kH6+m5nTDwUl2UDMn0nPtVcju7PtZ
	 mibZ94gDkk8XvYjRRzghc5R+AvCpgHNbWMc7GS/7DIGg8k+fO6KL34EHHbqXbWbJfc
	 p18vj/l2FdcuVdvJW/h/byYIZVP7UegKZWyrmQg76TfqoA7HjYF6xK9XzTyKMBDOQz
	 8KKkJH7U/N4CA==
Date: Tue, 10 Jun 2025 09:10:19 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, 
	Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
Message-ID: <sfzy2ojfzsjya24pbxw7fb77ua6smjixqjk7qrbt2i3q7wh25b@3kzz22tairgr>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
 <aEeZw4PTeOIe-u_d@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aEeZw4PTeOIe-u_d@redhat.com>

On Mon, Jun 09, 2025 at 10:34:43PM -0400, Joe Lawrence wrote:
> On Fri, May 09, 2025 at 01:17:23PM -0700, Josh Poimboeuf wrote:
> > +revert_patch() {
> > +	local patch="$1"
> > +	shift
> > +	local extra_args=("$@")
> > +	local tmp=()
> > +
> > +	( cd "$SRC" && git apply --reverse "${extra_args[@]}" "$patch" )
> > +	git_refresh "$patch"
> > +
> > +	for p in "${APPLIED_PATCHES[@]}"; do
> > +		[[ "$p" == "$patch" ]] && continue
> > +		tmp+=("$p")
> > +	done
> > +
> > +	APPLIED_PATCHES=("${tmp[@]}")
> > +}
> 
> You may consider a slight adjustment to revert_patch() to handle git
> format-patch generated .patches?  The reversal trips up on the git
> version trailer:
> 
>   warning: recount: unexpected line: 2.47.1

Thanks.  Looks like the normal apply with --recount also trips it up.  I
have the below:

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index f689a4d143c6..1ff5e66f4c53 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -337,7 +337,14 @@ apply_patch() {
 
 	[[ ! -f "$patch" ]] && die "$patch doesn't exist"
 
-	( cd "$SRC" && git apply "${extra_args[@]}" "$patch" )
+	(
+		cd "$SRC"
+
+		# The sed removes the version signature from 'git format-patch',
+		# otherwise 'git apply --recount' warns.
+		sed -n '/^-- /q;p' "$patch" |
+			git apply "${extra_args[@]}"
+	)
 
 	APPLIED_PATCHES+=("$patch")
 }
@@ -348,7 +355,12 @@ revert_patch() {
 	local extra_args=("$@")
 	local tmp=()
 
-	( cd "$SRC" && git apply --reverse "${extra_args[@]}" "$patch" )
+	(
+		cd "$SRC"
+
+		sed -n '/^-- /q;p' "$patch" |
+			git apply --reverse "${extra_args[@]}"
+	)
 	git_refresh "$patch"
 
 	for p in "${APPLIED_PATCHES[@]}"; do

