Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3008B3DFC4E
	for <lists+live-patching@lfdr.de>; Wed,  4 Aug 2021 09:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbhHDHxC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 Aug 2021 03:53:02 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50706 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235977AbhHDHxC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 Aug 2021 03:53:02 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1929421B67;
        Wed,  4 Aug 2021 07:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1628063569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q0WtFYaglWyt9DdtWG8gNU/Zq2IVGbULiEIOZV/nxGI=;
        b=Va4XCP3DYeg4L+7VjsjAcDIN4Gxhn9vqwG+MtWFMip8+be+Ao6nDCEk91VPPSoYx5DH4YU
        hZ5urwcIqdD05p/UmDJ/wVNHELYXi9w/7Ov44BrEl2DVlVHaz3vfh69AOLLppuFwJfh5R6
        YY3zo4TbijSzF/T9+q4eDoWrk2m6Zrg=
Received: from suse.cz (pmladek.tcp.ovpn1.prg.suse.de [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E8F3DA3B8C;
        Wed,  4 Aug 2021 07:52:48 +0000 (UTC)
Date:   Wed, 4 Aug 2021 09:52:46 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 26/38] livepatch: Replace deprecated CPU-hotplug
 functions.
Message-ID: <YQpHTrUqO/VtyqZG@alley>
References: <20210803141621.780504-1-bigeasy@linutronix.de>
 <20210803141621.780504-27-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803141621.780504-27-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2021-08-03 16:16:09, Sebastian Andrzej Siewior wrote:
> The functions get_online_cpus() and put_online_cpus() have been
> deprecated during the CPU hotplug rework. They map directly to
> cpus_read_lock() and cpus_read_unlock().
> 
> Replace deprecated CPU-hotplug functions with the official version.
> The behavior remains unchanged.
> 
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Miroslav Benes <mbenes@suse.cz>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: live-patching@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
