Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E453F22C
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 10:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfD3In0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 04:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfD3In0 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 04:43:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AD3821734;
        Tue, 30 Apr 2019 08:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556613805;
        bh=k4lffYt4nfcLJvq+4lOX31GNB0aCw11/OWOTdPr5ZkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yq4hYiya+lzKJr7EScWcV6JPy5s7m6J4wpYzCxASQqElg/wtHjkPK7ocOnO+EMSm4
         yBZRQlfIIpPZT7HglgQ5fxWKX+ojWb1mkBlr8e8y3/NqcABNy6Kig51QXGhdApjamW
         whswbyMaON/tSMuBMyHdRrTYUuIbbSlm7S3D5ggA=
Date:   Tue, 30 Apr 2019 10:43:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] livepatch: Use correct kobject cleanup function
Message-ID: <20190430084323.GC11737@kroah.com>
References: <20190430001534.26246-1-tobin@kernel.org>
 <20190430001534.26246-3-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430001534.26246-3-tobin@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 30, 2019 at 10:15:34AM +1000, Tobin C. Harding wrote:
> The correct cleanup function after a call to kobject_init_and_add() has
> succeeded is kobject_del() _not_ kobject_put().  kobject_del() calls
> kobject_put().
> 
> Use correct cleanup function when removing a kobject.
> 
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
