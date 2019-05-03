Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3CD12D76
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 14:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfECMXZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 08:23:25 -0400
Received: from ms.lwn.net ([45.79.88.28]:47944 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfECMXZ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 08:23:25 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id DAF647DE;
        Fri,  3 May 2019 12:23:22 +0000 (UTC)
Date:   Fri, 3 May 2019 06:23:20 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     "Tobin C. Harding" <me@tobin.cc>, Johan Hovold <johan@kernel.org>,
        "Tobin C. Harding" <tobin@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/5] kobject: Fix kernel-doc comment first line
Message-ID: <20190503062320.62849fd4@lwn.net>
In-Reply-To: <8e237ab7-681b-dccf-792f-264e3f6fcd2d@infradead.org>
References: <20190502023142.20139-1-tobin@kernel.org>
        <20190502023142.20139-4-tobin@kernel.org>
        <20190502073823.GQ26546@localhost>
        <20190502082539.GB18363@eros.localdomain>
        <20190502083922.GR26546@localhost>
        <20190503014015.GC7416@eros.localdomain>
        <8e237ab7-681b-dccf-792f-264e3f6fcd2d@infradead.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 2 May 2019 18:46:16 -0700
Randy Dunlap <rdunlap@infradead.org> wrote:

> I have seen this discussion before also.  And sometimes it is not even
> a discussion -- it's more of an edict.  To which I object/disagree.
> The current (or past) comment style is perfectly fine IMO.
> No caps needed.  No ending '.' needed.

For however much this matters...I really don't see that there needs to be
a rule one way or the other on this; the documentation serves its purpose
either way.  I guess I see it like "British or American spelling";
there's nothing to drive a conversion in either direction.

jon
