Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2220916BE3C
	for <lists+live-patching@lfdr.de>; Tue, 25 Feb 2020 11:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgBYKFn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Feb 2020 05:05:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:44780 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbgBYKFn (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Feb 2020 05:05:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EA0CEAD81;
        Tue, 25 Feb 2020 10:05:40 +0000 (UTC)
Date:   Tue, 25 Feb 2020 11:05:39 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Will Deacon <will@kernel.org>
cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        akpm@linux-foundation.org,
        "K . Prasad" <prasad@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Quentin Perret <qperret@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 0/3] Unexport kallsyms_lookup_name() and
 kallsyms_on_each_symbol()
In-Reply-To: <20200221114404.14641-1-will@kernel.org>
Message-ID: <alpine.LSU.2.21.2002251104130.11531@pobox.suse.cz>
References: <20200221114404.14641-1-will@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

CC live-patching ML, because this could affect many of its users...

On Fri, 21 Feb 2020, Will Deacon wrote:

> Hi folks,
> 
> Despite having just a single modular in-tree user that I could spot,
> kallsyms_lookup_name() is exported to modules and provides a mechanism
> for out-of-tree modules to access and invoke arbitrary, non-exported
> kernel symbols when kallsyms is enabled.
> 
> This patch series fixes up that one user and unexports the symbol along
> with kallsyms_on_each_symbol(), since that could also be abused in a
> similar manner.
> 
> Cheers,
> 
> Will
> 
> Cc: K.Prasad <prasad@linux.vnet.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Quentin Perret <qperret@google.com>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> 
> --->8
> 
> Will Deacon (3):
>   samples/hw_breakpoint: Drop HW_BREAKPOINT_R when reporting writes
>   samples/hw_breakpoint: Drop use of kallsyms_lookup_name()
>   kallsyms: Unexport kallsyms_lookup_name() and
>     kallsyms_on_each_symbol()
> 
>  kernel/kallsyms.c                       |  2 --
>  samples/hw_breakpoint/data_breakpoint.c | 11 ++++++++---
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> -- 
> 2.25.0.265.gbab2e86ba0-goog
> 

