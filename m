Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F9C1D4801
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2020 10:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgEOIUG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 May 2020 04:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbgEOIUG (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 May 2020 04:20:06 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6AD820657;
        Fri, 15 May 2020 08:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589530805;
        bh=MIlGuQgco5xlMobbfG+DhJtDOkUGJNUrRQxXMs79N0M=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=k+284gXvCo5VcDPPtjT7hCZ/LtFdXvCK5j1Qz0OUC5xHDCgcVZtXLGK4P4hEPPlum
         nCD9FhiCDZsPRlO4Lk8EGBsaURC0odEnVv//RboaNMUpkHO5kTzP2W09yOMX506QCd
         4Yl+ztZfz51Kyc1nz7bYRqkMPv8T5V7xS4aFJYq4=
Date:   Fri, 15 May 2020 10:20:01 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Joe Perches <joe@perches.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: adjust to livepatch .klp.arch removal
In-Reply-To: <509c316f-5b34-2859-49aa-e4fe4a407428@linux.vnet.ibm.com>
Message-ID: <nycvar.YFH.7.76.2005151019150.25812@cbobk.fhfr.pm>
References: <20200509073258.5970-1-lukas.bulwahn@gmail.com> <bfe91b2d-e319-bf12-6a15-4f200d0e8ea4@linux.vnet.ibm.com> <nycvar.YFH.7.76.2005142344230.25812@cbobk.fhfr.pm> <509c316f-5b34-2859-49aa-e4fe4a407428@linux.vnet.ibm.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 15 May 2020, Kamalesh Babulal wrote:

> Thanks, Jiri. I realized later, that the lib/livepatch directory also 
> needs to be included in the list of files maintained under livepatch. 
> Earlier, this week I had sent a patch to the mailing list that includes 
> both arch headers and lib/livepatch to the list of files, the link to 
> the patch is:
> 
> https://lore.kernel.org/live-patching/20200511061014.308675-1-kamalesh@linux.vnet.ibm.com/

Ah, I wasn't CCed, so it fell in between cracks, sorry. Could you please 
resend the lib/livepatch part separately? I'll apply it on top.

Thanks,

-- 
Jiri Kosina
SUSE Labs

