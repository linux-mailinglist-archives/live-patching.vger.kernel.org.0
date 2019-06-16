Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0EA5473CD
	for <lists+live-patching@lfdr.de>; Sun, 16 Jun 2019 10:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfFPIpK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 16 Jun 2019 04:45:10 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:41623 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfFPIpK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 16 Jun 2019 04:45:10 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hcQma-0007GQ-5m; Sun, 16 Jun 2019 10:45:00 +0200
Date:   Sun, 16 Jun 2019 10:44:59 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Miroslav Benes <mbenes@suse.cz>
cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, kamalesh@linux.vnet.ibm.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] stacktrace: Remove weak version of
 save_stack_trace_tsk_reliable()
In-Reply-To: <20190611141320.25359-2-mbenes@suse.cz>
Message-ID: <alpine.DEB.2.21.1906161044490.1760@nanos.tec.linutronix.de>
References: <20190611141320.25359-1-mbenes@suse.cz> <20190611141320.25359-2-mbenes@suse.cz>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 11 Jun 2019, Miroslav Benes wrote:

> Recent rework of stack trace infrastructure introduced a new set of
> helpers for common stack trace operations (commit e9b98e162aa5
> ("stacktrace: Provide helpers for common stack trace operations") and
> related). As a result, save_stack_trace_tsk_reliable() is not directly
> called anywhere. Livepatch, currently the only user of the reliable
> stack trace feature, now calls stack_trace_save_tsk_reliable().
> 
> When CONFIG_HAVE_RELIABLE_STACKTRACE is set and depending on
> CONFIG_ARCH_STACKWALK, stack_trace_save_tsk_reliable() calls either
> arch_stack_walk_reliable() or mentioned save_stack_trace_tsk_reliable().
> x86_64 defines the former, ppc64le the latter. All other architectures
> do not have HAVE_RELIABLE_STACKTRACE and include/linux/stacktrace.h
> defines -ENOSYS returning version for them.
> 
> In short, stack_trace_save_tsk_reliable() returning -ENOSYS defined in
> include/linux/stacktrace.h serves the same purpose as the old weak
> version of save_stack_trace_tsk_reliable() which is therefore no longer
> needed.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
