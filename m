Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19A14225D4
	for <lists+live-patching@lfdr.de>; Tue,  5 Oct 2021 14:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhJEMCw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 5 Oct 2021 08:02:52 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:59336 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhJEMCv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 5 Oct 2021 08:02:51 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6F8A2223E8;
        Tue,  5 Oct 2021 12:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633435260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VWhqUQ0FPWVDVeO7IAvTki4EdYjs8LtpN7dUmjU0ygg=;
        b=W54mXxBlS41sE0wraDLrZwk61MhDpt7f8SVlCYKH3Q7uszBDVSQlAL4E8IprElhWPfhdU8
        qH3q0Qo1qYdNgCq0vopuT1iKs+Vp6F9mctbap8+aUK0YODwcizTYsSdEvL8f1D3cU9UwiH
        qB/9DkhT4HDdDE/xzbq5r/856JavO/E=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 17DB7A3B83;
        Tue,  5 Oct 2021 12:01:00 +0000 (UTC)
Date:   Tue, 5 Oct 2021 14:00:59 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [PATCH v2 05/11] sched,livepatch: Use wake_up_if_idle()
Message-ID: <YVw+e6xh2VRErVJH@alley>
References: <20210929151723.162004989@infradead.org>
 <20210929152428.828064133@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929152428.828064133@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-09-29 17:17:28, Peter Zijlstra wrote:
> Make sure to prod idle CPUs so they call klp_update_patch_state().
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Thanks a lot for updating this API for livepatching.

Best Regards,
Petr
