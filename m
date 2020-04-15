Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176311AABA9
	for <lists+live-patching@lfdr.de>; Wed, 15 Apr 2020 17:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414645AbgDOPSf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Apr 2020 11:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1414618AbgDOPSb (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Apr 2020 11:18:31 -0400
Received: from linux-8ccs.fritz.box (p3EE2C7AC.dip0.t-ipconnect.de [62.226.199.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 036222078B;
        Wed, 15 Apr 2020 15:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586963910;
        bh=hfI1YAAeH1YLsyJL8AT3fmW+XOyfksoJnz+ksoISptA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CzRRiIHrXJVUaxJE1LN1SoTAInBxGPM/shexq+6nTJhWCl5TtWc9fz+RP4yZpTO5I
         m4BW0njHHuENU3tpoL2BIKMq3p1CEJVBdoNbYON16d5r5iAuuJBrooZgk6yK7O6gYu
         BQI2Hu3fwte/2jdJB5jUC1zQjqBYzqvcG6Kv2lJw=
Date:   Wed, 15 Apr 2020 17:18:26 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/7] livepatch: Remove .klp.arch
Message-ID: <20200415151825.GB6164@linux-8ccs.fritz.box>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <eb58cdddfd5d132c4d782978160d49764b09c764.1586881704.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <eb58cdddfd5d132c4d782978160d49764b09c764.1586881704.git.jpoimboe@redhat.com>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Josh Poimboeuf [14/04/20 11:28 -0500]:
[snip]
>diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
>index 2a591e6f8e6c..629ef7ffb6cf 100644
>--- a/Documentation/livepatch/module-elf-format.rst
>+++ b/Documentation/livepatch/module-elf-format.rst
>@@ -298,17 +298,7 @@ Examples:
>   Note that the 'Ndx' (Section index) for these symbols is SHN_LIVEPATCH (0xff20).
>   "OS" means OS-specific.
>
>-5. Architecture-specific sections
>-=================================
>-Architectures may override arch_klp_init_object_loaded() to perform
>-additional arch-specific tasks when a target module loads, such as applying
>-arch-specific sections. On x86 for example, we must apply per-object
>-.altinstructions and .parainstructions sections when a target module loads.
>-These sections must be prefixed with ".klp.arch.$objname." so that they can
>-be easily identified when iterating through a patch module's Elf sections
>-(See arch/x86/kernel/livepatch.c for a complete example).
>-
>-6. Symbol table and Elf section access
>+5. Symbol table and Elf section access

Nit: I think we need to fix the numbering in the Table of Contents too.
