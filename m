Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A24019502B
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2020 05:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgC0Evf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 27 Mar 2020 00:51:35 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:51721 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbgC0Eve (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 27 Mar 2020 00:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585284693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/bfRnjUF9okDBSODyoBPPTnAyjMFKuJMpBFwnLOeDBI=;
        b=L1T5HMg+xcZTQr7iw5q6kLnMU1WIku8PAU9IWNXE6rclsQaFV0zW5FECwdV0Tr9MM4tCyT
        DNqIi9VxFRHdXUPforj8eUQqrW/ofZyNp8glSMekoSqXSPjZBx3sLSkPGX352Op5qbQMDZ
        7jk6OeHYWLseetcgh8hnQUmuUWnzv2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-vZmYp6t-NtCnCeL4FoBT2Q-1; Fri, 27 Mar 2020 00:51:30 -0400
X-MC-Unique: vZmYp6t-NtCnCeL4FoBT2Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E952C107ACC4;
        Fri, 27 Mar 2020 04:51:27 +0000 (UTC)
Received: from treble (unknown [10.10.110.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B585219C69;
        Fri, 27 Mar 2020 04:51:21 +0000 (UTC)
Date:   Thu, 26 Mar 2020 23:51:19 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org
Subject: Re: [RESEND][PATCH v3 03/17] module: Properly propagate
 MODULE_STATE_COMING failure
Message-ID: <20200327045119.r7f6b6y2riyagemx@treble>
References: <20200324135603.483964896@infradead.org>
 <20200324142245.445253190@infradead.org>
 <20200325173519.GA5415@linux-8ccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200325173519.GA5415@linux-8ccs>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Mar 25, 2020 at 06:35:22PM +0100, Jessica Yu wrote:
> +++ Peter Zijlstra [24/03/20 14:56 +0100]:
> > Now that notifiers got unbroken; use the proper interface to handle
> > notifier errors and propagate them.
> > 
> > There were already MODULE_STATE_COMING notifiers that failed; notably:
> > 
> > - jump_label_module_notifier()
> > - tracepoint_module_notify()
> > - bpf_event_notify()
> > 
> > By propagating this error, we fix those users.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Cc: jeyu@kernel.org
> > ---
> > kernel/module.c |   10 +++++++---
> > 1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -3751,9 +3751,13 @@ static int prepare_coming_module(struct
> > 	if (err)
> > 		return err;
> > 
> > -	blocking_notifier_call_chain(&module_notify_list,
> > -				     MODULE_STATE_COMING, mod);
> > -	return 0;
> > +	err = blocking_notifier_call_chain_robust(&module_notify_list,
> > +			MODULE_STATE_COMING, MODULE_STATE_GOING, mod);
> > +	err = notifier_to_errno(err);
> > +	if (err)
> > +		klp_module_going(mod);
> > +
> > +	return err;
> > }
> > 
> > static int unknown_module_param_cb(char *param, char *val, const char *modname,
> > 
> 
> This looks fine to me - klp_module_going() is only called after
> successful klp_module_coming(), and klp_module_going() is fine with
> mod->state still being MODULE_STATE_COMING here. Would be good to have
> livepatch folks double check. Which reminds me - Miroslav had pointed
> out in the past that if there is an error when calling the COMING
> notifiers, the GOING notifiers will be called while the mod->state is
> still MODULE_STATE_COMING. I've briefly looked through all the module
> notifiers and it looks like nobody is looking at mod->state directly
> at least.
> 
> Acked-by: Jessica Yu <jeyu@kernel.org>

Looks good to me.  klp_module_going() is already called in other
load_module() error scenarios so this should be fine from a livepatch
standpoint.

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh

